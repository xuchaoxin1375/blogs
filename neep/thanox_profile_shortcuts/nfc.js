if (shortcutLaunched == true && shortcutValue == 'NFC') {     if (hw.isNfcEnabled() == false) {         (ui.showShortToast('打开NFC:✔✔') )+hw.enableNfc()     } } else if (shortcutLaunched == true && shortcutValue == 'NFC') {     if (hw.isNfcEnabled() == true) {         (ui.showShortToast('关闭NFC:'))+hw.disableNfc()     } }