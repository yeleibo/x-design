%使用Sidekick(https://github.com/fluttertools/sidekick/releases)帮助使用fvm%

%安装fvm%
dart pub global activate fvm

%配置环境变量-path%
\AppData\Local\Pub\Cache\bin
%设置缓存地址flutter的sdk下载地址%
FVM_CACHE_PATH=D:\FlutterSDK
%查看可以安装的flutter%
fvm releases

%安装flutter版本%
fvm install 3.13.8

%选择你要使用的版本,在项目目录下运行%
fvm use 3.13.8

%项目.gitignore中添加%
.fvm/flutter_sdk

%查看安装的flutter版本%
fvm list

%删除已安装的某个 Flutter 的版本%
fvm remove

%项目下配置fvm%
