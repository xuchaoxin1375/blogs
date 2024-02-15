[toc]

## powershell文字转语音

- 免费简单
  - [Powershell: Text To Speech in 3 lines of code | Scripting Library](https://www.scriptinglibrary.com/languages/powershell/powershell-text-to-speech/)
  - [Powershell Text To Speech | How To Guide - the Sysadmin Channel](https://thesysadminchannel.com/powershell-text-to-speech-how-to-guide/)
- 付费服务
  - [Quickstart: The Speech CLI - Speech service - Azure AI services | Microsoft Learn](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/spx-basics?tabs=windowsinstall%2Cpowershell)

### 函数

- ```
  Function New-TextToSpeechMessage
  {
      <#
  .SYNOPSIS
      This will use Powershell to have a message read out loud through your computer speakers.
   
   
  .NOTES
      Name: New-TextToSpeechMessage
      Author: cxxu
   
  .LINK
  
   
  .EXAMPLE
      New-TextToSpeechMessage -Message 'This is the text I want to have read out loud' -Voice Zira
  #>
      [CmdletBinding()]
      param(
          [Parameter(
              Position = 0,
              Mandatory = $true
          )]
   
          [string]    $Message,
   
   
          [Parameter(
              Position = 1,
              Mandatory = $false
          )]
   
          [ValidateSet( 'Zira','Huihui','David')]
          [string]    $Voice = 'Zira'
      )
   
      BEGIN
      {
          if (-not ([appdomain]::currentdomain.GetAssemblies() | Where-Object { $_.Location -eq 'C:\Windows\Microsoft.Net\assembly\GAC_MSIL\System.Speech\v4.0_4.0.0.0__31bf3856ad364e35\System.Speech.dll' }))
          {
              Add-Type -AssemblyName System.Speech
          }
      }
   
      PROCESS
      {
          try
          {
              $NewMessage = New-Object System.Speech.Synthesis.SpeechSynthesizer
   
              $NewMessage.SelectVoice("Microsoft $Voice Desktop")
              $NewMessage.Speak($Message)
       
          }
          catch
          {
              Write-Error $_.Exception.Message
          }        
      }
   
      END {}
  }
  ```

  