# JianSan-Wallpaper

### swift写的一个剑网三壁纸app

![image](https://github.com/6ag/JianSan-Wallpaper/blob/master/1.gif)

## 如何使用
### 导入框架

将项目中 `Vender` 目录下的 `JFContextSheet` 目录拖到你自己的项目。

### 初始化 **JFContextSheet**

**JFContextSheet** 初始化需要自己创建 `JFContextItem` 对象，每个 `JFContextItem` 代表一个选项，需要传递选项的标题和图片。然后将这些选项通过构造方法传递给 **JFContextSheet** 进行初始化。
**注意:** 选项的点击事件是根据代理来回调的，所以我们需要指定代理对象，这里指定为当前控制器。

```swift
let contextItem1 = JFContextItem(itemName: "返回", itemIcon: "content_icon_back")
let contextItem2 = JFContextItem(itemName: "预览", itemIcon: "content_icon_preview")
let contextItem3 = JFContextItem(itemName: "下载", itemIcon: "content_icon_download")
let contextSheet = JFContextSheet(items: [contextItem1, contextItem2, contextItem3])
contextSheet.delegate = self
```

### 实现代理 **JFContextSheetDelegate**

这个方法会返回按钮的标题，可以根据标题判断点击的选项

```swift
func contextSheet(contextSheet: JFContextSheet, didSelectItemWithItemName itemName: String) {
  switch (itemName) {
  case "返回":
    break
  case "预览":
    break
  case "下载":
    break
  default:
    break
  }
}
```
