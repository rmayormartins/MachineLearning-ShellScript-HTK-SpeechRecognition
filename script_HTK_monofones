#!/bin/bash

##MONTA PASTAS NECESSARIAS
cd /media/Dados/ODIN/33/HTK/htk/tidigits

mkdir -p hmm/mix01/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05}
mkdir -p hmm/mix02/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05}
mkdir -p hmm/mix04/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05}
mkdir -p hmm/mix08/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05}
mkdir -p hmm/mix16/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05}
mkdir -p hmm/mix32/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05}
mkdir -p log/{mix01/,mix02/,mix04/,mix08/,mix16/,mix32/,hvite}
mkdir -p result

##LISTA DE ALVOS
cd /media/Dados/ODIN/33/HTK/htk/tidigits/train

find `pwd` -name '*.wav' | gawk '{ print $1 " " $1}' | sed 's/wav$/mfc/g' > /media/Dados/ODIN/33/HTK/htk/tidigits/hcopy_train.list

cd /media/Dados/ODIN/33/HTK/htk/tidigits/test

find `pwd` -name '*.wav' | gawk '{ print $1 " " $1}' | sed 's/wav$/mfc/g' > /media/Dados/ODIN/33/HTK/htk/tidigits/hcopy_test.list

cd /media/Dados/ODIN/33/HTK/htk/HTKTools

##EXTRACAO DE PARAMETROS

./HCopy -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/hcopy.conf -S /media/Dados/ODIN/33/HTK/htk/tidigits/hcopy_train.list

./HCopy -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/hcopy.conf -S /media/Dados/ODIN/33/HTK/htk/tidigits/hcopy_test.list


##VERIFICACAO DE MFCC
echo -e " \033[41;1;37m Verificando MFCC com HList \033[0m "
./HList -t /media/Dados/ODIN/33/HTK/htk/tidigits/train/man/gt/3b.mfc

##LISTA TODOS MFCC DE TREINO
cd /media/Dados/ODIN/33/HTK/htk/tidigits/train
echo -e " \033[41;1;37m Listando MFCC de treino \033[0m "
find `pwd` -name '*.mfc' -print > /media/Dados/ODIN/33/HTK/htk/tidigits/HCompV_train.scp

#####COLOCA A PASTA PROTO E O PROTO DENTRO!!!
cd /media/Dados/ODIN/33/HTK/htk/HTKTools
echo -e " \033[41;1;37m Inicializando com HCompV \033[0m "
./HCompV -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -f 0.01 -m -S /media/Dados/ODIN/33/HTK/htk/tidigits/HCompV_train.scp -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/proto/proto

cd /media/Dados/ODIN/33/HTK/htk/tidigits
echo -e " \033[41;1;37m Criando hmmdefs \033[0m "
python hmmdef.py /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm00/proto /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm00/hmmdefs

cd /media/Dados/ODIN/33/HTK/htk/HTKTools
echo -e " \033[41;1;37m HLEd para Treino \033[0m "
./HLEd -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -d /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/digit.led /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_train.mlf

echo -e " \033[41;1;37m HLEd para Teste \033[0m "
./HLEd -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_test.mlf -d /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/digit.led /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf

cd /media/Dados/ODIN/33/HTK/htk/tidigits/train
find `pwd` -name '*.mfc' -print > /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp

cd /media/Dados/ODIN/33/HTK/htk/HTKTools

##### MIX 1 - ITERACAO 1 A 5 #############################################
for i in {1,2,3,4,5}
do
ii=$(($i - 1))
echo -e " \033[41;1;37m HERest Single MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ii/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix01/hmm0$i
done
#############################################

##### MIX 2 - ITERACAO 1 A 5 #############################################
./HHEd -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm05/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu2.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix02/log_split_mix02

for i in {1,2,3,4,5}
do
ii=$(($i - 1))
echo -e " \033[41;1;37m HERest 2 MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm0$ii/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix02/hmm0$i
done
#############################################

##### MIX 4 - ITERACAO 1 A 5 #############################################
./HHEd -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm05/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu4.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix04/log_split_mix04

for i in {1,2,3,4,5}
do
ii=$(($i - 1))
echo -e " \033[41;1;37m HERest 4 MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm0$ii/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix04/hmm0$i
done
#############################################

##### MIX 8 - ITERACAO 1 A 5 #############################################
./HHEd -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm05/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu8.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix08/log_split_mix08

for i in {1,2,3,4,5}
do
ii=$(($i - 1))
echo -e " \033[41;1;37m HERest 8 MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$ii/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix08/hmm0$i
done
#############################################

##### MIX 16 - ITERACAO 1 A 5 #############################################
./HHEd -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm05/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu16.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix16/log_split_mix16

for i in {1,2,3,4,5}
do
ii=$(($i - 1))
echo -e " \033[41;1;37m HERest 16 MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm0$ii/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix16/hmm0$i
done
#############################################

##### MIX 32 - ITERACAO 1 A 5 #############################################
./HHEd -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm05/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu32.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix32/log_split_mix32

for i in {1,2,3,4,5}
do
ii=$(($i - 1))
echo -e " \033[41;1;37m HERest 32 MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm0$ii/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix32/hmm0$i
done
#############################################

echo -e " \033[41;1;37m HParse Criando Rede \033[0m "
./HParse /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.syn /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net

cd /media/Dados/ODIN/33/HTK/htk/tidigits/test
find `pwd` -name '*.mfc' -print > /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp

cd /media/Dados/ODIN/33/HTK/htk/HTKTools

echo -e " \033[41;1;37m HVite Testando mix 1 \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm05/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix01_hmm05.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -80.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix01_hmm05
echo -e " \033[41;1;37m HVite Testando mix 2 \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm05/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix02_hmm05.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -80.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix02_hmm05
echo -e " \033[41;1;37m HVite Testando mix 4 \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm05/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix04_hmm05.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -80.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix04_hmm05
echo -e " \033[41;1;37m HVite Testando mix 8 \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm05/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix08_hmm05.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -80.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix08_hmm05
echo -e " \033[41;1;37m HVite Testando mix 16 \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm05/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix16_hmm05.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -80.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix16_hmm05
echo -e " \033[41;1;37m HVite Testando mix 32 \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm05/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix32_hmm05.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -80.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix32_hmm05



echo -e " \033[41;1;37m HResults Resultado mix 1 \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -p -t -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/dic/word.list /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix01_hmm05.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix01_hmm05
echo -e " \033[41;1;37m HResults Resultado mix 2 \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -p -t -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/dic/word.list /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix02_hmm05.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix02_hmm05
echo -e " \033[41;1;37m HResults Resultado mix 4 \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -p -t -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/dic/word.list /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix04_hmm05.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix04_hmm05
echo -e " \033[41;1;37m HResults Resultado mix 8 \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -p -t -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/dic/word.list /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix08_hmm05.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix08_hmm05
echo -e " \033[41;1;37m HResults Resultado mix 16 \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -p -t -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/dic/word.list /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix16_hmm05.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix16_hmm05
echo -e " \033[41;1;37m HResults Resultado mix 32 \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -p -t -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/dic/word.list /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix32_hmm05.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix32_hmm05













