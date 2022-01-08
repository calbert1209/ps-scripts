# PowerShell Scripts

Some great advice I wish I had heard earlier when I was just starting:

> One of the easiest ways to get started learning to program is to write scripts. Do you use a computer? Pay attention to the repetitive tasks you do on your computer. There is a good chance those can be scripted. Sure, you may need to invest some time to get your script running, but you will definitely learn something.

The only way to truly learn something is when you need it. Using the scripts I created has, of course, stream-lined computer tasks, but moreover it has been very satisfying.

# Setup

🐧 I think most scripts can be run on [Powershell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-6) as well as good-ol' Windows PowerShell.

🐋 The ffmpeg scripts require [Docker](https://www.docker.com/products/docker-desktop) and [an image that runs ffmpeg](https://hub.docker.com/r/jrottenberg/ffmpeg) as its entry point.

💿 Mp3 file tag editing requires [TagLibSharp.](https://www.nuget.org/packages/TagLibSharp)

# Highlights

## cryptography

`.\Import-SymetricEncryptCmdlets.ps1`

Encrypt / decrypt your secrets using a password.

(🚨☝🏻I am no expert, which means I can't certify how secure this method is. Please don't trust your really important secrets to a script posted on GitHub by some dude you don't know. Especially if he has a beard!🧔🏻)

```ps1
# 'dot source' the functions to encrypt and decrypt
. '.\cryptography\Import-SymetricalEncryptionCmdlets.ps1'

# create a sorta-secure key (password)
$pswd = Get-Password

# encrypt piped in text
"Jenny's phone number is 867-5309" | Out-EncryptedContent -Path C:\MyDeepDarkSecret.txt -Key $pswd

# later...

# Decrypt your secret. TIP: You can save a step by combining two steps
Get-EncryptedContent -Path C:\MyDeepDarkSecret.txt -Key (Get-Password)
# output: Jenny's phone number is 867-5309

# BONUS TIP: pipe the text out to the Window's clipboard.
# sorry mac friends 🍏😥
Get-EncryptedContent -Path C:\MyDeepDarkSecret.txt -Key (Get-Password) | Set-Clipboard
```

## ffmpeg-based

`Import-FfmpegImageUtilities.ps1`

Invoke your local ffmpeg docker image by ID to convert media files. (I am partial to [`jrottenberg/ffmpeg`](https://hub.docker.com/r/jrottenberg/ffmpeg))

`Import-GifCreator.ps1`

Use your local ffmpeg docker image to convert videos to gifs. Awesome memes are just around the corner. 😎

## mp3-tag-editing

`EasyBatchEditTags.ps1`

Use the [TagLibSharp](https://www.nuget.org/packages/TagLibSharp) library to batch edit the tags of an album's mp3 files. (Remember those? 👴🏻👨🏻‍🦳👵🏻)

## miscellaneous

`Import-DotEnvUtils.ps1`

Load secrets as environment variables, similar to the Node JS `dotEnv` package.

`Import-OutVoice.ps1`

Forget Cortana 😋, you want Powershell to talk to you.🥰 Output text as speech.

## posh-quetzal

This one was originally its own project, but I'll include it here.

Do you like Windows 10's hero image lock screens? I do. They are periodically updated in the background when your connected to the Internet, and can be found in the local app data folder for the UWP app that controls the lock screen. But that's a bit of a hassle, so use this script instead to copy everything to local sub-folders. I keep this one on a USB drive so I can collect all the screens I see on different devices at work in once place.

**⚠ Note:** The logic that only copies over images that are not yet in the cache is not yet complete, so you'd best use the `-Force` flag to copy everything, even stuff you already have.

```ps1
# copies all the current landscape-orientation lock screen images to a local subfolder
Get-LocalLandscapes -Force
```

## Contribute

Got free time? I'd love to hear constructive feedback. Please post an issue.

## Authors

- [calbert1209](https://github.com/calbert1209) - Initial Work
