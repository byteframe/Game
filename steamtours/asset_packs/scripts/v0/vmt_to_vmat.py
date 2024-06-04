# Converts Source 1 .vmt material files to simple Source 2 .vmat files.
#
# Copyright (c) 2016 Rectus
# Copyright (c) 201X OtherPeople(?)
# Copyright (c) 2022 byteframe
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Usage Instructions:
# python vmt_to_vmat.py DIR

import sys
import os
import os.path
from os import path
import re
from PIL import Image
import PIL.ImageOps

SHADER = 'vr_standard'
TEXTURE_FILEEXT = '.tga'
MAP_SUBSTRING = '_alpha'
OVERWRITE_VMAT = False

current_file = ''
# material types need to be lowercase because python is a bit case sensitive
materialTypes = [
"vertexlitgeneric",
"unlitgeneric",
"lightmappedgeneric",
"patch",
"teeth",
"eyes",
"eyeball",
#"modulate",
"water", #TODO: integrate water/refract shaders into this script
"refract",
"worldvertextransition",
#"lightmapped_4wayblend",
"unlittwotexture", #TODO: make this system functional
#"lightmappedreflective",
#"cables"
]
ignoreList = [
    "vertexlitgeneric_hdr_dx9",
    "vertexlitgeneric_dx9",
    "vertexlitgeneric_dx8",
    "vertexlitgeneric_dx7",
    "lightmappedgeneric_hdr_dx9",
    "lightmappedgeneric_dx9",
    "lightmappedgeneric_dx8",
    "lightmappedgeneric_dx7",
]
def text_parser(filepath, separator="="):
    return_dict = {}
    with open(filepath, "r") as f:
        for line in f:
            if not line.startswith("//"):
                line = line.replace('\t', '').replace('\n', '')
                line = line.split(separator)
                return_dict[line[0]] = line[1]
    return return_dict
def parseVMTParameter(line, parameters):
    words = []
    if line.startswith('\t') or line.startswith(' '):
        words = re.split(r'\s+', line, 2)
    else:
        words = re.split(r'\s+', line, 1)
    words = list(filter(len, words))
    if len(words) < 2:
        return
    key = words[0].strip('"')
    if key.startswith('/'):
        return
    if not key.startswith('$'):
        if not key.startswith('include'):
            return
    val = words[1].strip('\n')
    #### zps crutch
    val = val.replace('models//', 'models/')
    val = val.replace('deadcity//', 'deadcity/')
    val = val.replace('deadcity_unique//', 'deadcity_unique/')
    val = val.replace('swamp//', 'swamp/')
    val = val.replace('tools//', 'tools/')
    val = val.replace('clubzombo//', 'clubzombo/')
    #### seens in a few textures in neotokyosource
    val = val.replace('materials//', 'materials/')
    val = val.replace('=', ' ')
    val = val.replace('\t', ' ')
    # remove comments, HACK
    commentTuple = val.partition('//')
    if(val.strip('"' + "'") == ""):
        # print("+ No value found, moving on")
        return
    if not commentTuple[0] in parameters:
        parameters[key] = commentTuple[0]
def fixTexturePath(p, addonString = ""):
    retPath = p.strip().strip('"')
    retPath = retPath.replace(' ', '_')
    retPath = retPath.replace('//', '/')
    retPath = retPath.replace('.vmt', '')
    # this was for contagion, it might have fixed it before left4dead fuck up
    retPath = re.sub('\t', '  ', retPath)
    # retPath = re.sub('[/\\\]+360', '/', retPath)
    # retPath = re.sub('[\s_]*\[\$.*\]', '', retPath)
    retPath = retPath.replace('\\', '/') # Convert paths to use forward slashes.
    retPath = retPath.replace('.vtf', '') # remove any old extensions
    retPath = '"materials/' + retPath + addonString + TEXTURE_FILEEXT + '"'
    return retPath
def fixVector(s):
    s = s.strip('"][}{ ') # some VMT vectors use {}
    parts = [str(float(i)) for i in s.split(' ')]
    extra = (' 0.0' * max(3 - s.count(' '), 0) )
    return '"[' + ' '.join(parts) + extra + ']"'
def extractAlphaTextures(localPath, invertColor):
    localPath = localPath.replace(' ', '_')
    image_path = PATH_TO_CONTENT_ROOT + localPath
    mask_path = PATH_TO_CONTENT_ROOT + localPath[:-4] + MAP_SUBSTRING + TEXTURE_FILEEXT
    image_path = image_path.replace('\\', '/')
    mask_path = mask_path.replace('\\', '/')
    if path.lexists(image_path):
        # Open the image and convert it to RGBA, just in case it was indexed
        image = Image.open(image_path).convert('RGBA')

        # Extract just the alpha channel
        alpha = image.split()[-1]

        # Unfortunately the alpha channel is still treated as such and can't be dumped as-is
        # Create a new image with an opaque black background
        bg = Image.new("RGBA", image.size, (0,0,0,255))

        # Copy the alpha channel to the new image using itself as the mask
        bg.paste(alpha)
        if invertColor:
            r,g,b,a = bg.split()
            rgb_image = Image.merge('RGB', (r,g,b))
            inverted_image = PIL.ImageOps.invert(rgb_image)
            r2,g2,b2 = inverted_image.split()
            final_transparent_image = Image.merge('RGB', (r2,g2,b2))
            final_transparent_image.save(mask_path)
            final_transparent_image.close()
        else:
            bg.save(mask_path)
            bg.close()
    else:
      print("NO ALPHA: " + current_file + " : " + image_path)
def flipNormalMap(localPath):
    localPath = localPath.replace(' ', '_')
    image_path = PATH_TO_CONTENT_ROOT + localPath
    image_path = image_path.replace('\\', '/')
    if path.lexists(image_path):
        # Open the image and convert it to RGBA, just in case it was indexed
        image = Image.open(image_path).convert('RGBA')
        # Extract just the green channel
        r,g,b,a = image.split()
        g = PIL.ImageOps.invert(g)
        final_transparent_image = Image.merge('RGBA', (r,g,b,a))
        final_transparent_image.save(image_path)

def getVmatParameter(key, val):
    key = key.strip('$').lower()

    # Dict for converting parameters
    convert = {
        #VMT paramter: VMAT parameter, value, additional lines to add. The last two variables take functions or strings, or None for using the old value.
        'basetexture': ('TextureColor', fixTexturePath, None),
        'basetexture2': ('TextureLayer1Color', fixTexturePath, '\tF_BLEND 1\n'),
        'bumpmap': ('TextureNormal', fixTexturePath, None),
        'bumpmap2': ('TextureLayer1Normal', fixTexturePath, '\tF_BLEND_NORMALS 1\n'),
        'blendmodulatetexture': ('TextureLayer1RevealMask', fixTexturePath, None),
        'normalmap': ('TextureNormal', fixTexturePath, None),
        'envmap': ('F_SPECULAR', '1', '\tF_SPECULAR_CUBE_MAP 1\n\tF_SPECULAR_CUBE_MAP_PROJECTION 1\n\tg_flCubeMapBlurAmount "1.000"\n\tg_flCubeMapScalar "1.000"\n'), #Assumes env_cubemap
        #'envmaptint': ('TextureReflectance', fixVector, None),
        'envmapmask': ('TextureReflectance', fixTexturePath, None),
        'color': ('g_vColorTint', None, None), #Assumes being used with basetexture
        'selfillum': ('g_flSelfIllumScale', '"1.000"', None),
        'selfillumtint': ('g_vSelfIllumTint', None, None),
        'selfillummask': ('TextureSelfIllumMask', fixTexturePath, None),
        'phongexponenttexture': ('TextureGlossiness', fixTexturePath, None),
        'translucent': ('F_TRANSLUCENT', None, '\tg_flOpacityScale "1.000"\n'),
        'additive': ('F_ADDITIVE_BLEND', None, None),
        'nocull': ('F_RENDER_BACKFACES', None, None),
        'decal':( 'F_OVERLAY', None, None),
    }

    if key in convert:
        outValue = val
        additionalLines = ''

        if isinstance(convert[key][1], str):
            outValue = convert[key][1]
        elif hasattr(convert[key][1], '__call__'):
            outValue = convert[key][1](val)

        if isinstance(convert[key][2], str):
            additionalLines = convert[key][2]
        elif hasattr(convert[key][2], '__call__'):
            additionalLines = convert[key][2](val)

        '''if isinstance(convert[key][3], bool):
            if(val.replace('"', '') == "0" or val.replace('"', '') == "false"):
                return ''
        elif hasattr(convert[key][3], '__call__'):
            print("Error: no bool at the end of dict!!")
            return ''
            '''
        return '\t' + convert[key][0] + ' ' + outValue + '\n' + additionalLines
    return ''

def parseDir(dirName):
    files = []
    for root, dirs, fileNames in os.walk(dirName):
        for fileName in fileNames:	
            if fileName.lower().endswith('.vmt'):
                files.append(os.path.join(root,fileName))
    return files

PATH_TO_CONTENT_ROOT = sys.argv[1] + "/"
globalVars = text_parser(PATH_TO_CONTENT_ROOT + "global_vars.txt", " = ")
if(PATH_TO_CONTENT_ROOT == ""):
    print("ERROR: Please open vmt_to_vmat in your favorite text editor, and modify PATH_TO_CONTENT_ROOT to lead to your games content files (i.e. ...\steamvr_environments\content\steamtours_addons\)")
    quit()
print('Source 2 Material Converter! By Rectus>Alphyne>caseytube>byteframe via Github.')
print('--------------------------------------------------------------------------------------------------------')

# Verify file paths
fileList = []
if(len(sys.argv) == 3):
    absFilePath = os.path.abspath(sys.argv[2])
    if os.path.isdir(absFilePath):
        fileList.extend(parseDir(absFilePath))
    elif(absFilePath.lower().endswith('.vmt')):
        fileList.append(absFilePath)
    else:
        print("ERROR: File path is invalid. required format: vmt_to_vmat.py modName C:\optional\path\to\root")
        quit()
elif(len(sys.argv) == 2):
    absFilePath = os.path.abspath(PATH_TO_CONTENT_ROOT)
    if os.path.isdir(absFilePath):
        fileList.extend(parseDir(absFilePath))
    elif(absFilePath.lower().endswith('.vmt')):
        fileList.append(absFilePath)
    else:
        print("ERROR: File path is invalid. required format: vmt_to_vmat.py modName C:\optional\path\to\root")
        quit()
else:
    print("ERROR: CMD Arguments are invalid. Required format: vmt_to_vmat.py modName C:\optional\path\to\root")
    quit()

# Main function, loop through every .vmt
for fileName in fileList:
    current_file = fileName.replace(PATH_TO_CONTENT_ROOT, '')
    # print(current_file)
    vmtParameters = {}
    validMaterial = False
    validPatch = False
    skipNextLine = False
    matType = ""
    patchFile = ""
    basetexturePath = ""
    bumpmapPath = ""
    phong = False; #also counts for rimlight since they feed off each other
    baseMapAlphaPhongMask = False
    envMap = False
    baseAlphaEnvMapMask = False
    envMapMask = False
    normalMapAlphaEnvMapMask = False
    selfIllum = False
    translucent = False #also counts for alphatest
    alphatest = False
    wroteReflectanceRange = False
    with open(fileName, 'r', encoding='latin-1') as vmtFile:
        for line in vmtFile.readlines():
            if any(wd in line.lower() for wd in materialTypes):
                validMaterial = True
                matType = line.lower()
            if skipNextLine:
                if "]" in line or "}" in line:
                    skipNextLine = False
            else:
                parseVMTParameter(line, vmtParameters)
            if any(wd in line.lower() for wd in ignoreList):
                skipNextLine = True

    if '"patch"' in matType.lower():
        patchFile = vmtParameters["include"].replace('"', '').replace("'", '').replace("\\", "/");
        print("+ Patching materials details from: " + patchFile)
        refFile = PATH_TO_CONTENT_ROOT + patchFile
        # byteframe at the end of v2: This likely never worked. and SEEMS to only have affected berimbau which doesned use hl2 phew?
        # wait, no, it did work, the link was probably good because I used hl2 throughout
        # so why is resource compilter finding tons of materials now? herm no it probably was broken
        # without the annoucnment of failure to find an hl2 file then it seems all kinda hazy part of the v3 material script overhaul
        if not os.path.lexists(refFile):
           refFile = PATH_TO_CONTENT_ROOT + "../asset_pack_hl2/" + patchFile
        if os.path.lexists(refFile):
          with open(refFile, 'r') as vmtFile:
              for line in vmtFile.readlines():
                  if any(wd in line.lower() for wd in materialTypes):
                      validPatch = True
                  parseVMTParameter(line, vmtParameters)
          if not validPatch:
              print("+ Patch file is not a valid material. Skipping!")
              continue

    if validMaterial:
        vmatFileName = fileName.replace('.vmt', '') + '.vmat'
        if os.path.lexists(vmatFileName) and not OVERWRITE_VMAT:
            # print('+ File already exists. Skipping!')
            continue

        # print('+ Converting ' + os.path.basename(fileName))
        with open(vmatFileName, 'w') as vmatFile:
            vmatFile.write('// Converted with vmt_to_vmat.py\n\n')
            vmatFile.write('Layer0\n{\n\tshader "' + SHADER + '.vfx"\n\n')
            for key, val in vmtParameters.items():
                vmatFile.write(getVmatParameter(key, val))
                if(key.lower() == "$phong" or key.lower() == "$rimlight"):
                    if val.strip('"' + "'") != "0":
                        phong = True
                elif(key.lower() == "$basemapalphaphongmask"):
                    if val.strip('"' + "'") != "0":
                        baseMapAlphaPhongMask = True
                elif(key.lower() == "$selfillum"):
                    if val.strip('"' + "'") != "0":
                        # print("selfillum")
                        selfIllum = True
                elif(key.lower() == "$translucent"):
                    if val.strip('"' + "'") != "0":
                        translucent = True
                elif(key.lower() == "$alphatest"):
                    if val.strip('"' + "'") != "0":
                        alphatest = True
                elif(key.lower() == "$basetexture"):
                    basetexturePath = val.lower().strip().replace('.vtf', '').replace('.vmt', '')
                    # basetexturePath = re.sub('[/\\\]+360', '/', basetexturePath)
                    # basetexturePath = re.sub('[\s_]*\[\$.*\]', '', basetexturePath)
                elif(key.lower() == "$bumpmap"):
                    bumpmapPath = val.lower().strip().replace('.vtf', '').replace('.vmt', '')
                    # bumpmapPath = re.sub('[/\\\]+360', '/', bumpmapPath)
                    # bumpmapPath = re.sub('[\s_]*\[\$.*\]', '', bumpmapPath)
                elif(key.lower() == "$envmap"):
                    envMap = True
                elif(key.lower() == "$basealphaenvmapmask"):
                    if val.strip('"' + "'") != "0":
                        baseAlphaEnvMapMask = True
                elif(key.lower() == "$normalmapalphaenvmapmask"):
                    if val.strip('"' + "'") != "0":
                        normalMapAlphaEnvMapMask = True
                elif(key.lower() == "$envmapmask"):
                    if val.strip('"' + "'") != "0":
                        envMapMask = True

            #check if base texture is empty
            if "metal" in vmatFileName:
                vmatFile.write("\tg_flMetalness 1.000\n")
            if translucent:
                vmatFile.write('\tF_TRANSLUCENT 1\n\tTextureTranslucency ' + fixTexturePath(basetexturePath, MAP_SUBSTRING) + '\n')
                extractAlphaTextures("materials/" + basetexturePath.replace("\\", '/').replace('"', '') + TEXTURE_FILEEXT, False)
            if alphatest:
                vmatFile.write('\tF_ALPHA_TEST 1\n\tTextureTranslucency ' + fixTexturePath(basetexturePath, MAP_SUBSTRING) + '\n')
                extractAlphaTextures("materials/" + basetexturePath.replace("\\", '/').replace('"', '') + TEXTURE_FILEEXT, False)

            hasReflectance = False

            if phong:
                if not wroteReflectanceRange:
                    vmatFile.write('\t' + globalVars["reflectanceRange"] + '\n')
                    wroteReflectanceRange = True
                if baseMapAlphaPhongMask and basetexturePath != '':
                    hasReflectance = True
                    vmatFile.write('\tTextureReflectance ' + fixTexturePath(basetexturePath, MAP_SUBSTRING) + '\n')
                    extractAlphaTextures("materials/" + basetexturePath.replace('"', '') + TEXTURE_FILEEXT, True)
                else:
                    if(bumpmapPath == '') and not (baseAlphaEnvMapMask or normalMapAlphaEnvMapMask):
                        vmatFile.write('\tTextureReflectance "[1.000000 1.000000 1.000000 0.000000]"\n')
                        #extractAlphaTextures("materials/" + basetexturePath.replace('"', '') + TEXTURE_FILEEXT, True)
                    else:
                        hasReflectance = True
                        vmatFile.write('\tTextureReflectance ' + fixTexturePath(bumpmapPath, MAP_SUBSTRING) + '\n')
                        extractAlphaTextures("materials/" + bumpmapPath.replace('"', '') + TEXTURE_FILEEXT, True)
            if envMap:
                if not wroteReflectanceRange:
                    vmatFile.write('\t' + globalVars["reflectanceRange"] + '\n')
                    wroteReflectanceRange = True
                if baseAlphaEnvMapMask and not normalMapAlphaEnvMapMask and basetexturePath != '' and not hasReflectance:
                    vmatFile.write('\tTextureReflectance ' + fixTexturePath(basetexturePath, MAP_SUBSTRING) + '\n')
                    #Weird hack, apparently envmaps for LightmappedGeneric are flipped, whereas VertexLitGeneric ones aren't
                    if "lightmappedgeneric" in matType:
                        extractAlphaTextures("materials/" + basetexturePath.replace('"', '') + TEXTURE_FILEEXT, True)
                    elif "vertexlitgeneric" in matType:
                        extractAlphaTextures("materials/" + basetexturePath.replace('"', '') + TEXTURE_FILEEXT, True)
                if normalMapAlphaEnvMapMask and bumpmapPath != '' and not hasReflectance:
                    vmatFile.write('\tTextureReflectance ' + fixTexturePath(bumpmapPath, MAP_SUBSTRING) + '\n')
                    #Weird hack, apparently envmaps for LightmappedGeneric are flipped, whereas VertexLitGeneric ones aren't
                    if "lightmappedgeneric" in matType:
                        extractAlphaTextures("materials/" + bumpmapPath.replace('"', '') + TEXTURE_FILEEXT, True)
                    elif "vertexlitgeneric" in matType:
                        extractAlphaTextures("materials/" + bumpmapPath.replace('"', '') + TEXTURE_FILEEXT, True)

            if selfIllum:
                vmatFile.write('\tF_SELF_ILLUM 1\n\tTextureSelfIllumMask ' + fixTexturePath(basetexturePath, MAP_SUBSTRING) + '\n')
                extractAlphaTextures("materials/" + basetexturePath.replace('"', '') + TEXTURE_FILEEXT, False)

            vmatFile.write('}\n')

    bumpmapConvertedList = PATH_TO_CONTENT_ROOT + "convertedBumpmaps.txt"
    if not os.path.lexists(bumpmapConvertedList):
        print('ERROR: Please create an empty text file named "convertedBumpmaps.txt" in the root of your mod files (i.e. content/steamtours_addons/hl2)')
        quit()

    # flip the green channels of any normal maps
    if(bumpmapPath != ""):
        foundMaterial = False
        with open(bumpmapConvertedList, 'r+') as bumpList: #change the read type to write
            for line in bumpList.readlines():
                if line.rstrip() == bumpmapPath.rstrip():
                    foundMaterial = True

            if not foundMaterial:
                flipNormalMap(fixTexturePath(bumpmapPath).strip("'" + '"'))
                print("flipped normal map of " + bumpmapPath)
                #append bumpmapPath to bumpmapCovertedList
                bumpList.write(bumpmapPath + "\n")
                bumpList.close()
sys.exit()
# TODO: reparse the vmt, see i.e. if alphatest, then TextureTranslucency "path/to/tex/name_alpha.tga",
# basemap alpha can either be a transparency mask, selfillum mask, or specular mask
# normalmap alpha can be a phong mask by default

# if $translucent/$alphatest
	# TextureTranslucency "path/to/tex/basetexture_alpha.tga"
# if $rimlight/$phong in vmt
	# if $basemapalphaphongmask in vmt
		#TextureRimMask/TextureSpecularMask "path/to/tex/basetexture_alpha.tga"
	# else
		#TextureRimMask/TextureSpecularMask "path/to/tex/bumpmap_alpha.tga"
# if $selfillum in vmt
	# Add Mask 1
	# TextureSelfIllumMask "path/to/tex/basetexture_alpha.tga"