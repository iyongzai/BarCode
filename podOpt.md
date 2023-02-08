## 代码

创建 tag: 

```
git tag tag_name
```

推送tag到远程仓库: 

```
git push origin tag_name
```

删除 tag: 

```
git tag -d tag_name
```

删除远程tag:

```
git push origin :refs/tags/tag_name
```

**注意：GitHub 需要创建Release版本**

## podspec

校验podspec: 

```
pod spec lint BarCode.podspec
```

## 提交到cocoapods

第一次提交需要先注册，官方给出的例子为：

```
pod trunk register ortaacocoapods.org 'Orta Therox' --description=' macbook air'
```

orta @cocoapods。org
邮箱，注册时成功后会给你发一封邮件用来验证。
Orta Therox
用户名。
macbook air
一个描述，这个描述很耐人寻味，才开始的时候百度到的教程写了一句“这里写描述〞，我就随便写了一句，结果没通过，然后把官网
上的指令粘上去，替换自己的邮箱和用户名，将“macbook air“改成了“macbook pro‘，然后就通过了l-_-l。

注册成功后提交：

```
pod trunk push BarCode.podspec --allow-warnings
```

提交成功后可能会有延迟,可以执行:

```
rm ~/Library/Caches/CocoaPods/search_ index. ison
pod setup
```

## 删除

```
pod trunk delete BarCode 0.0.1
```
