#!/bin/bash

#
# 脚本说明：通过fio测试存储LUN性能数据
# 每个测试用例的执行结果输出到output文件夹目录下；
# TODO：实现从output文件夹执行输出中提取IOPS，BW等性能数据绘制表格
#
ShowHelp ()
{
    echo "Block device benchmark test tool. "
    echo ""
    echo "Usage: ./fio-benchmark.sh [VAR=VALUE]..."
    echo ""
    echo "Configuration:"
    echo "param1                        The target block device of current benchmark."
    echo "param2                        The type of I/O operate, read, write, randread, randwrite, randrw or all."
    echo "param3                        The block size of I/O operate, 4k, 8k, 16k, 32k, 64k, 128k, 256k, 512k, 1M or all."
    echo "param4                        The runtime (count by second) of every benchmark test case."
    echo ""
    echo "--h                           Pinrt this help information."
    echo ""
    echo "eg: ./fio-benchmark.sh nvme0n1 all all 60"
    echo ""
    echo "Thanks for use block device benchmark test tool."
    echo "AUTHOR"
    echo "       Written by Bend Sha."
    echo ""
}

GetParamName ()
{
    echo $1 | awk -F"=" '{print $1}'

    echo $1
}

InitExecEnv ()
{
    if [ ! -d "./output" ]
    then
        mkdir ./output
    fi
}

ParamSelete ()
{
    for params in $@
    do
        pname=`GetParamName $params`
        case "$pname" in
            "--t")
                IOType=`GetParamValue $params`
                ;;
            "--bs")
                BlockSize=`GetParamValue $params`
                ;;
            "--help")
                NEED_HELP=1
                ;;
            *)
            NEED_HELP=1
            echo "Unknown parameter $params"
            break
            ;;
        esac
    done
}

CheckParams ()
{
    ParamSelete $@

    if [ "$NEED_HELP" == "1" ]
    then
        ShowHelp
        exit 0
    fi

    if [ "${IOType}" != "read" ] && [ "${IOType}" != "write" ] && [ "${IOType}" != "randrw" ] && [ "${IOType}" != "all" ]
    then
        ShowError "Invalid parameter,--t=read/write/randrw/all."
        ShowHelp
        exit 0
    fi

    if [ -z "${IOType}" ]
    then
        IOType=all
    fi

    if [ "${BlockSize}" != "4k" ] && [ "${BlockSize}" != "8k" ] && [ "${BlockSize}" != "16k" ] && 
          ${BlockSize}" != "32k" ] && [ "${BlockSize}" != "64k" ] && [ "${BlockSize}" != "128k" ] && 
          ${BlockSize}" != "256k" ] && [ "${BlockSize}" != "512k" ] && [ "${BlockSize}" != "1M" ] && [ "${BlockSize}" != "all" ]
    then
        ShowError "Invalid parameter,--bs=4k/8k/16k/32k/64k/128k/256k/512k/1M/all."
        ShowHelp
        exit 0
    fi

    if [ -z "${BlockSize}" ]
    then
        BlockSize=all
    fi
}

SetExecParameters ()
{
    if [ -z "${DeviceName}" ]
    then
        ShowHelp
        exit 0
    fi

    sed -i "s/^filename=.*/filename=\/dev\/$DeviceName/g" -r ./config/*/*
    if [ "${Runtime}" == "" ]
    then
        sed -i "s/^runtime=.*/runtime=60/g" -r ./config/*/*
    else
        sed -i "s/^runtime=.*/runtime=$Runtime/g" -r ./config/*/*
    fi
}

ExecTestCaseBS4K ()
{
    # block size = 4k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 4k-write test case..."
        fio ./config/4k/4k-write.conf > ./output/4k-write.log
        cat ./output/4k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 4k-randwrite test case..."
        fio ./config/4k/4k-randwrite.conf > ./output/4k-randwrite.log
        cat ./output/4k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 4k-read test case..."
        fio ./config/4k/4k-read.conf > ./output/4k-read.log
        cat ./output/4k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 4k-randread test case..."
        fio ./config/4k/4k-randread.conf > ./output/4k-randread.log
        cat ./output/4k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 4k-randrw test case..."
        fio ./config/4k/4k-randrw.conf > ./output/4k-randrw.log
        cat ./output/4k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS8K ()
{
    # block size = 8k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 8k-write test case..."
        fio ./config/8k/8k-write.conf > ./output/8k-write.log
        cat ./output/8k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 8k-randwrite test case..."
        fio ./config/8k/8k-randwrite.conf > ./output/8k-randwrite.log
        cat ./output/8k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 8k-read test case..."
        fio ./config/8k/8k-read.conf > ./output/8k-read.log
        cat ./output/8k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 8k-randread test case..."
        fio ./config/8k/8k-randread.conf > ./output/8k-randread.log
        cat ./output/8k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 8k-randrw test case..."
        fio ./config/8k/8k-randrw.conf > ./output/8k-randrw.log
        cat ./output/8k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS16K ()
{
    # block size = 16k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 16k-write test case..."
        fio ./config/16k/16k-write.conf > ./output/16k-write.log
        cat ./output/16k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 16k-randwrite test case..."
        fio ./config/16k/16k-randwrite.conf > ./output/16k-randwrite.log
        cat ./output/16k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 16k-read test case..."
        fio ./config/16k/16k-read.conf > ./output/16k-read.log
        cat ./output/16k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 16k-randread test case..."
        fio ./config/16k/16k-randread.conf > ./output/16k-randread.log
        cat ./output/16k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 16k-randrw test case..."
        fio ./config/16k/16k-randrw.conf > ./output/16k-randrw.log
        cat ./output/16k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS32K ()
{
    # block size = 32k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 32k-write test case..."
        fio ./config/32k/32k-write.conf > ./output/32k-write.log
        cat ./output/32k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 32k-randwrite test case..."
        fio ./config/32k/32k-randwrite.conf > ./output/32k-randwrite.log
        cat ./output/32k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 32k-read test case..."
        fio ./config/32k/32k-read.conf > ./output/32k-read.log
        cat ./output/32k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 32k-randread test case..."
        fio ./config/32k/32k-randread.conf > ./output/32k-randread.log
        cat ./output/32k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 32k-randrw test case..."
        fio ./config/32k/32k-randrw.conf > ./output/32k-randrw.log
        cat ./output/32k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS64K ()
{
    # block size = 64k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 64k-write test case..."
        fio ./config/64k/64k-write.conf > ./output/64k-write.log
        cat ./output/64k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 64k-randwrite test case..."
        fio ./config/64k/64k-randwrite.conf > ./output/64k-randwrite.log
        cat ./output/64k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 64k-read test case..."
        fio ./config/64k/64k-read.conf > ./output/64k-read.log
        cat ./output/64k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 64k-randread test case..."
        fio ./config/64k/64k-randread.conf > ./output/64k-randread.log
        cat ./output/64k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 64k-randrw test case..."
        fio ./config/64k/64k-randrw.conf > ./output/64k-randrw.log
        cat ./output/64k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS128K ()
{
    # block size = 128k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 128k-write test case..."
        fio ./config/128k/128k-write.conf > ./output/128k-write.log
        cat ./output/128k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 128k-randwrite test case..."
        fio ./config/128k/128k-randwrite.conf > ./output/128k-randwrite.log
        cat ./output/128k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 128k-read test case..."
        fio ./config/128k/128k-read.conf > ./output/128k-read.log
        cat ./output/128k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 128k-randread test case..."
        fio ./config/128k/128k-randread.conf > ./output/128k-randread.log
        cat ./output/128k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 128k-randrw test case..."
        fio ./config/128k/128k-randrw.conf > ./output/128k-randrw.log
        cat ./output/128k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS256K ()
{
    # block size = 256k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 256k-write test case..."
        fio ./config/256k/256k-write.conf > ./output/256k-write.log
        cat ./output/256k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 256k-randwrite test case..."
        fio ./config/256k/256k-randwrite.conf > ./output/256k-randwrite.log
        cat ./output/256k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 256k-read test case..."
        fio ./config/256k/256k-read.conf > ./output/256k-read.log
        cat ./output/256k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 256k-randread test case..."
        fio ./config/256k/256k-randread.conf > ./output/256k-randread.log
        cat ./output/256k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 256k-randrw test case..."
        fio ./config/256k/256k-randrw.conf > ./output/256k-randrw.log
        cat ./output/256k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS512K ()
{
    # block size = 512k
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 512k-write test case..."
        fio ./config/512k/512k-write.conf > ./output/512k-write.log
        cat ./output/512k-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 512k-randwrite test case..."
        fio ./config/512k/512k-randwrite.conf > ./output/512k-randwrite.log
        cat ./output/512k-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 512k-read test case..."
        fio ./config/512k/512k-read.conf > ./output/512k-read.log
        cat ./output/512k-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 512k-randread test case..."
        fio ./config/512k/512k-randread.conf > ./output/512k-randread.log
        cat ./output/512k-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 512k-randrw test case..."
        fio ./config/512k/512k-randrw.conf > ./output/512k-randrw.log
        cat ./output/512k-randrw.log | grep "IOPS"
    fi
}

ExecTestCaseBS1M ()
{
    # block size = 1M
    if [ "${IOType}" == "write" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 1M-write test case..."
        fio ./config/1M/1M-write.conf > ./output/1M-write.log
        cat ./output/1M-write.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randwrite" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 1M-randwrite test case..."
        fio ./config/1M/1M-randwrite.conf > ./output/1M-randwrite.log
        cat ./output/1M-randwrite.log | grep "IOPS"
    fi

    if [ "${IOType}" == "read" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 1M-read test case..."
        fio ./config/1M/1M-read.conf > ./output/1M-read.log
        cat ./output/1M-read.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randread" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 1M-randread test case..."
        fio ./config/1M/1M-randread.conf > ./output/1M-randread.log
        cat ./output/1M-randread.log | grep "IOPS"
    fi

    if [ "${IOType}" == "randrw" ] || [ "${IOType}" == "all" ] 
    then
        echo "start exec 1M-randrw test case..."
        fio ./config/1M/1M-randrw.conf > ./output/1M-randrw.log
        cat ./output/1M-randrw.log | grep "IOPS"
    fi
}

ExecBenchmark ()
{
    if [ "${BlockSize}" == "4k" ]
    then
        ExecTestCaseBS4K
    elif [ "${BlockSize}" == "8k" ]
    then
        ExecTestCaseBS8K
    elif [ "${BlockSize}" == "16k" ]
    then
        ExecTestCaseBS16K
    elif [ "${BlockSize}" == "32k" ]
    then
        ExecTestCaseBS32K
    elif [ "${BlockSize}" == "64k" ]
    then
        ExecTestCaseBS64K
    elif [ "${BlockSize}" == "128k" ]
    then
        ExecTestCaseBS128K
    elif [ "${BlockSize}" == "256k" ]
    then
        ExecTestCaseBS256K
    elif [ "${BlockSize}" == "512k" ]
    then
        ExecTestCaseBS512K
    elif [ "${BlockSize}" == "1M" ]
    then
        ExecTestCaseBS1M
    else
        ExecTestCaseBS4K
        ExecTestCaseBS8K
        ExecTestCaseBS16K
        #ExecTestCaseBS32K
        ExecTestCaseBS64K
        ExecTestCaseBS128K
        ExecTestCaseBS256K
        ExecTestCaseBS512K
        ExecTestCaseBS1M
    fi
}

HandleResul ()
{
    # achieve fio execute result
    mv output $(date '+%Y%m%d%H%M%S')

    # TODO：实现从output文件夹执行输出中提取IOPS，BW等性能数据绘制表格
    # sed -n "$(grep -n ABC 1.log | tail -1 | cut -d : -f 1),+10p" ABC.log
}

DeviceName=$1
IOType=$2
BlockSize=$3
Runtime=$4

InitExecEnv
#CheckParams
SetExecParameters
ExecBenchmark
HandleResul


