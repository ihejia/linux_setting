#!/bin/sh
conda_ver="Anaconda3-2020.11-Linux-x86_64.sh"
conda_path="/usr/local/anaconda3"

if [ -f ./$conda_ver ] ; then
	 rm -rf $conda_ver
fi

wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/$conda_ver

if [ ! -e "$conda_ver" ] ; then
	echo "Download error,Please check the networks!"
    else
	sh $conda_ver -b -u -p $conda_path
	rm -rf $conda_ver
	chown -R 1000:1000 $conda_path

	#couda初始化设置
	echo "Conda安装完毕,是否初始化客户端"
        read -p "输入y同意或者任意键取消:" conda_set ;
        if  [ $conda_set = 'y' ] ; then
	        $conda_path/bin/conda init
        else
                echo -e "选择不初始化conda环境,后期可使用命令 $conda_path/bin/conda init 完成初始化"
        fi

	#tensorflow环境配置
	echo "是否创建tensorflow测试环境"
	read -p "输入y同意或者任意键取消:" tensorflow_set ;
	if  [ $tensorflow_set = 'y' ] ; then
	#	$conda_path/bin/conda create -n tf-gpu python=3.6 tensorflow-gpu==1.13.1 -y //更新版本以适应30系列显卡
		$conda_path/bin/conda create -n tf21 python=3.7 tensorflow-gpu==2.1 cudatoolkit=10.1 -y
	else
		echo "选择不安装Tensorflow测试环境！"
	fi

        #pythorch环境配置
        echo "是否创建pythorch测试环境"
        read -p "输入y同意或者任意键取消:" pythorch_set ;
	if  [ $pythorch_set = 'y' ] ; then
                $conda_path/bin/conda create -n torchbenchmark python=3.7 pytorch torchtext torchvision -c pytorch-nightly -y
        else
                echo "选择不安装pytorch测试环境"
        fi

	#合并tensorflow与pytorch环境，由于30系列显卡不支持1.13故将tensorflow升级到2.1版本
	# echo "是否创建tensorflow、pytorch测试环境"
	# read -p "输入y同意或者任意键取消:" tensorflow_set ;
	# if  [ $tensorflow_set = 'y' ] ; then
	# 	$conda_path/bin/conda create -n tf21 python=3.7 tensorflow-gpu==2.1 cudatoolkit=10.1 pytorch torchtext torchvision -c pytorch-nightly -y
	# else
	# 	echo "选择不安装测试环境！"
	# fi

	chown -R 1000:1000 $conda_path
fi

