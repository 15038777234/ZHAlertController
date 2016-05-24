# ZHAlertController
封装系统的UIAlertControll UIAlertView UIActionsheet

![](https://github.com/15038777234/ZHAlertController/blob/master/Simulator%20Screen%20Shot%202015年11月16日%20上午10.15.39.png)


![](https://github.com/15038777234/ZHAlertController/blob/master/Simulator%20Screen%20Shot%202015年11月16日%20上午10.15.44.png)


![](https://github.com/15038777234/ZHAlertController/blob/master/Simulator%20Screen%20Shot%202015年11月16日%20上午10.15.46.png)

## 安装 
直接拖到工程里面

## 使用

```
[[ZHAlertControler alertControllerWithStyle:style title:@"这是标题" message:@"这是描述" cannelButton:@"取消" otherButtons:@[@"其他"] complete:^(ZHAlertControler * _Nonnull controller) {

}] showInController:self]; 
```
