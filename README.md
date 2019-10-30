# vscode-remote-php

针对国内网络预先完成apt下载、安装了composer并将composer设置为国内源的vscode php开发用容器

本项目中的[Dockerfile](https://github.com/microsoft/vscode-remote-try-php/blob/master/.devcontainer/Dockerfile)由[微软范例php开发容器](https://github.com/Microsoft/vscode-remote-try-php)中提取后修改

相较于原本的Dockerfile，做了如下修改

- 通过apt多安装了zsh less locales git-flow vim这5个组件
- 安装了oh-my-zsh
- 将所有涉及apt的操作合为一句RUN以避免缓存文件出现在docker的层叠卷中
- 生成了中文locale支持，在终端中中文的输入与输出都不会乱码了
- 时区设置为+0800
- 安装了composer
- 将composer设置为国内源
- 设置默认shell为zsh

## 容器配置

在代码中容器配置如下

``` json
{
    "name": "PHP",
    "dockerFile": "Dockerfile",
    // Use 'settings' to set *default* container specific settings.json values on container create.
    // You can edit these settings after create using File > Preferences > Settings > Remote.
    "settings": {},
    // Uncomment the next line if you want to publish any ports.
    // "appPort": [],
    // Uncomment the next line to run commands after the container is created.
    // "postCreateCommand": "php -v",
    "extensions": [
        "felixfbecker.php-debug",
        "felixfbecker.php-intellisense"
    ]
}
```
