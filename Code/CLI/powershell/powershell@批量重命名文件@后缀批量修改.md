[toc]



例如,将所有jpg文件的后缀`.jpg`替换为`.webp`

```powershell
ls "*.jpg"|%{ rni -Path $_ -NewName ((Split-Path -LeafBase $_).ToString()+".webp") -Verbose}
```

