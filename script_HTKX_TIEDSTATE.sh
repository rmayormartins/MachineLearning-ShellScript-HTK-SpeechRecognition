#!/bin/bash

##MONTA PASTAS NECESSARIAS
cd /media/Dados/ODIN/33/HTK/htk/tidigits

mkdir -p hmm/mix01/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05/,hmm06/,hmm07/,hmm08/,hmm09/,hmm010/,hmm011/,hmm012/,hmm013/,hmm014/,hmm015/,hmm016}
mkdir -p hmm/mix02/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05/,hmm06/,hmm07/,hmm08/,hmm09}
mkdir -p hmm/mix04/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05/,hmm06/,hmm07/,hmm08/,hmm09}
mkdir -p hmm/mix08/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05/,hmm06/,hmm07/,hmm08/,hmm09}
mkdir -p hmm/mix16/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05/,hmm06/,hmm07/,hmm08/,hmm09}
mkdir -p hmm/mix32/{hmm00/,hmm01/,hmm02/,hmm03/,hmm04/,hmm05/,hmm06/,hmm07/,hmm08/,hmm09}
mkdir -p log/{mix01/,mix02/,mix04/,mix08/,mix16/,mix32/,hvite}
mkdir -p result

######################################## EXTRACAO DE CARACTERISTICAS ########################################

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
####gera aligned que eh o tidigits_phone_train com "sp"
./HLEd -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/aligned.mlf -d /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/digit.led /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_train.mlf

echo -e " \033[41;1;37m HLEd para Teste \033[0m "
./HLEd -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_test.mlf -d /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit.dic /media/Dados/ODIN/33/HTK/htk/tidigits/digit.led /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf

cd /media/Dados/ODIN/33/HTK/htk/tidigits/train
find `pwd` -name '*.mfc' -print > /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp

cd /media/Dados/ODIN/33/HTK/htk/HTKTools

######################################## FIM EXTRACAO DE CARACTERISTICAS ########################################

######################################## FIXING SILENCE MODEL AND SHORT PAUSE ##### MAKING TRIPHONES ########################################

################ MIX 1 - ITERACAO 1 A 5 ################ 
for i in {1,2,3}
do
ia=$(($i - 1))
echo -e " \033[41;1;37m Iniciando HERest Single MIX iteração $i \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_phone_train.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ia/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$i /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix01/hmm0$i
done

#FIXING SILENCE MODE
ib=$(($i + 1)) #hmm04
echo -e " \033[41;1;37m Fixing silence model - incluindo short pause em hmmdefs do hmm0$ib \033[0m "
cp /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$i/hmmdefs /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ib/hmmdefs
cat /media/Dados/ODIN/33/HTK/htk/tidigits/fixedsilence | sed -n '1,4p' >> /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ib/hmmdefs
cat /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$i/hmmdefs | sed -n '574,578p' >> /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ib/hmmdefs
cat /media/Dados/ODIN/33/HTK/htk/tidigits/fixedsilence | sed -n '5,9p' >> /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ib/hmmdefs

ic=$(($ib + 1)) #hmm05
echo -e " \033[41;1;37m Criando monophones1 em hmm0$ic \033[0m "
./HHEd -A -D -T 1 -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ib/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ic /media/Dados/ODIN/33/HTK/htk/tidigits/sil.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/monophones1

for id in {6,7,8} #reestima com o aligned
do
ie=$(($id - 1))
echo -e " \033[41;1;37m Continuando HERest Single MIX iteração $id em hmm0$id COM ALIGNED \033[0m "
./HERest -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/aligned.mlf -t 250.0 150.0 1000.0 -w 1 -v 0.0001 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ie/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$id /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/monophones1 > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix01/hmm0$id
done

####GERA TRIPHONES1
echo -e " \033[41;1;37m Gera Triphones \033[0m "
./HLEd -A -D -T 1 -n /media/Dados/ODIN/33/HTK/htk/tidigits/triphones1 -i /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/mktri.led /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/aligned.mlf

echo -e " \033[41;1;37m Mktri.hed \033[0m "
cd /media/Dados/ODIN/33/HTK/htk/tidigits
perl maketrihed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/monophones1 /media/Dados/ODIN/33/HTK/htk/tidigits/triphones1


###EXECUTANDO HHEd 
cd /media/Dados/ODIN/33/HTK/htk/HTKTools
if=$(($id + 1)) #criará hmm09
echo -e " \033[41;1;37m Criando hmmdefs em hmm$if usando mktri.hed \033[0m "
./HHEd -A -D -T 1 -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$id/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$if /media/Dados/ODIN/33/HTK/htk/tidigits/mktri.hed /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/monophones1


echo -e " \033[41;1;37m Reestima com o aligned \033[0m "
for ig in {10,11,12} #reestima com o aligned
do
ih=$(($ig - 1))
echo -e " \033[41;1;37m Novamente HERest Single MIX iteração $ig em hmm0$ig COM ALIGNED e COM TRIPHONE !!! \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -t 250.0 150.0 1000.0 -s stats -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ih/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ig /media/Dados/ODIN/33/HTK/htk/tidigits/triphones1 > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix01/hmm0$ig
done

######################################## FIM FIXING SILENCE MODEL AND SHORT PAUSE E MAKING TRIPHONES ########################################

#################################################TIED STATE###########################################################

####### MAKING TIED-STATE TRIPHONES1
echo -e " \033[41;1;37m HDMan criando fullist flog e dict-tri !!! \033[0m "
./HDMan -A -D -T 1 -b sp -n /media/Dados/ODIN/33/HTK/htk/tidigits/fullist -g /media/Dados/ODIN/33/HTK/htk/tidigits/global.ded -l /media/Dados/ODIN/33/HTK/htk/tidigits/flog /media/Dados/ODIN/33/HTK/htk/tidigits/dict-tri /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit2.dic

cd /media/Dados/ODIN/33/HTK/htk/tidigits
cat fullist triphones1 >> fullist1
echo -e " \033[41;1;37m fixfullist \033[0m "
perl fixfullist.pl /media/Dados/ODIN/33/HTK/htk/tidigits/fullist1 /media/Dados/ODIN/33/HTK/htk/tidigits/fullist

echo -e " \033[41;1;37m mkclscript \033[0m "
perl mkclscript.prl TB 350 /media/Dados/ODIN/33/HTK/htk/tidigits/phonemes/phones > /media/Dados/ODIN/33/HTK/htk/tidigits/tree-2.hed 

cat tree-1.hed tree-2.hed > tree-3.hed
cat /media/Dados/ODIN/33/HTK/htk/tidigits/tree-4.hed | sed -n '1,7p' >> /media/Dados/ODIN/33/HTK/htk/tidigits/tree-3.hed

cat tree-3.hed > tree.hed

echo -e " \033[41;1;37m HHEd \033[0m "
cd /media/Dados/ODIN/33/HTK/htk/HTKTools
ii=$(($ig + 1)) #hmm13
./HHEd -B -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ig/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ii /media/Dados/ODIN/33/HTK/htk/tidigits/tree.hed /media/Dados/ODIN/33/HTK/htk/tidigits/triphones1


for ij in {14,15} 
do
il=$(($ij - 1))
echo -e " \033[41;1;37m Novamente HERest Single MIX iteração $ij em hmm0$ij COM TIEDLIST !!! \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -s stats -t 250.0 150.0 1000.0 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$il/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ij /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix01/hmm0$ij
done
################ FIM MIX 1 ############################

################################################# FIM TIED STATE###########################################################


################################################# MISTURAS GAUSSIANAS #####################################################

################  MIX 2 ###############################

#ITERACAO 1 A 2 - TIED STATE E TRIPHONES #
echo -e " \033[44;1;37m INICIANDO MIX 2 TIED TRI!!! \033[0m " #ij eh 15
./HHEd -B -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ij/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu2tritiedX2.hed /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix02/log_split_mix02

for jb in {1,2} 
do
jc=$(($jb - 1))
echo -e " \033[44;1;37m HERest 2 MIX iteração $jb TIED STATE - TRIPHONES \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -s stats -t 250.0 150.0 1000.0 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm0$jc/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm0$jb /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix02/hmm0$jb
done
################ FIM MIX 2 ##############################

################  MIX 4 ###############################

#ITERACAO 1 A 2 - TIED STATE E TRIPHONES #
echo -e " \033[42;1;37m INICIANDO MIX 4 TIED TRI!!! \033[0m " #jb eh 9
./HHEd -B -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm0$jb/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu4tritiedX2.hed /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix04/log_split_mix04

for lb in {1,2} 
do
lc=$(($lb - 1))
echo -e " \033[42;1;37m HERest 4 MIX iteração $lb TIED STATE - TRIPHONES \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -s stats -t 250.0 150.0 1000.0 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm0$lc/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm0$lb /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix04/hmm0$lb
done
################ FIM MIX 4 ##############################

################  MIX 8 ###############################

#ITERACAO 1 A 2 - TIED STATE E TRIPHONES #
echo -e " \033[46;1;37m INICIANDO MIX 8 TIED TRI!!! \033[0m " #lb eh 9
./HHEd -B -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm0$lb/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu8tritiedX2.hed /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix08/log_split_mix088

for mb in {1,2} 
do
mc=$(($mb - 1))
echo -e " \033[46;1;37m HERest 8 MIX iteração $mb TIED STATE - TRIPHONES \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -s stats -t 250.0 150.0 1000.0 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$mc/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$mb /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix08/hmm0$mb
done
################ FIM MIX 8 ##############################

################  MIX 16 ###############################

#ITERACAO 1 A 2 - TIED STATE E TRIPHONES #
echo -e " \033[45;1;37m INICIANDO MIX 16 TIED TRI!!! \033[0m " #mb eh 9
./HHEd -B -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$mb/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu16tritiedX2.hed /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix16/log_split_mix01616

for nb in {1,2} 
do
nc=$(($nb - 1))
echo -e " \033[45;1;37m HERest 16 MIX iteração $nb TIED STATE - TRIPHONES \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -s stats -t 250.0 150.0 1000.0 -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm0$nc/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm0$nb /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix16/hmm0$nb
done
################ FIM MIX 16 ##############################

################  MIX 32 ###############################


#ITERACAO 7 A 9 - TIED STATE E TRIPHONES #
echo -e " \033[40;1;37m INICIANDO MIX 32 TIED TRI!!! \033[0m " #nb eh 9
./HHEd -B -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$mb/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm00 /media/Dados/ODIN/33/HTK/htk/tidigits/hed/mu32tritiedX2.hed /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix32/log_split_mix03232

for ob in {1,2} 
do
oc=$(($ob - 1))
echo -e " \033[40;1;37m HERest 32 MIX iteração $ob TIED STATE - TRIPHONES \033[0m "
./HERest -A -D -T 1 -C /media/Dados/ODIN/33/HTK/htk/tidigits/config.fig -I /media/Dados/ODIN/33/HTK/htk/tidigits/wintri.mlf -s stats -S /media/Dados/ODIN/33/HTK/htk/tidigits/HERest_train.scp -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm0$oc/hmmdefs -M /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm0$ob /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/mix32/hmm0$ob

done
################ FIM MIX 32 ##############################

################################################# FIM MISTURAS GAUSSIANAS #####################################################

echo -e " \033[41;1;37m HParse Criando Rede \033[0m "
./HParse /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.syn /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net

echo -e " \033[41;1;37m Gerando lista mfc \033[0m "
cd /media/Dados/ODIN/33/HTK/htk/tidigits/test
find `pwd` -name '*.mfc' -print > /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp



################################################# HVITE ########################################################################
cd /media/Dados/ODIN/33/HTK/htk/HTKTools

#HVITE MIX 1###########
echo -e " \033[41;1;37m HVite Testando mix 1 COM TIED STATE E TRIPHONE  \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix01/hmm0$ij/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix01_hmm0$ij.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -0.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix01_hmm0$ij

#######################

#HVITE MIX 2###########
echo -e " \033[44;1;37m HVite Testando mix 2 COM TIED STATE E TRIPHONE \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix02/hmm0$jb/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix02_hmm0$jb.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -0.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix02_hmm0$jb

########################

#HVITE MIX 4###########
echo -e " \033[42;1;37m HVite Testando mix 4 COM TIED STATE E TRIPHONE \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix04/hmm0$lb/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix04_hmm0$lb.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -0.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix04_hmm0$lb

########################

#HVITE MIX 8###########
echo -e " \033[46;1;37m HVite Testando mix 8 COM TIED STATE E TRIPHONE \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix08/hmm0$mb/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix08_hmm0$mb.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -0.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix08_hmm0$mb

########################

#HVITE MIX 16###########
echo -e " \033[45;1;37m HVite Testando mix 16 COM TIED STATE E TRIPHONE \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix16/hmm0$nb/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix16_hmm0$nb.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -0.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix16_hmm0$nb

########################

#HVITE MIX 32###########
echo -e " \033[40;1;37m HVite Testando mix 32 COM TIED STATE E TRIPHONE \033[0m "
./HVite -T 0001 -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -H /media/Dados/ODIN/33/HTK/htk/tidigits/hmm/mix32/hmm0$ob/hmmdefs -S /media/Dados/ODIN/33/HTK/htk/tidigits/HVite_test.scp -i /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix32_hmm0$ob.mlf -w /media/Dados/ODIN/33/HTK/htk/tidigits/grammar/digit.net -p -0.0 -s 5.0 /media/Dados/ODIN/33/HTK/htk/tidigits/dic/digit3.dic /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist > /media/Dados/ODIN/33/HTK/htk/tidigits/log/hvite/log_recout_mix32_hmm0$ob

########################



################################################# FIM HVITE ##########################################################################



################################################# HRESULTS ##########################################################################

#HRESULTS MIX 1###########
echo -e " \033[41;1;37m HResults Testando mix 1 COM TRIPHONE e TIED STATE  \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix01_hmm0$ij.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix01_hmm0$ij
##########################


#HRESULTS MIX 2###########

echo -e " \033[44;1;37m HResults Testando mix 2 COM TRIPHONE e TIED STATE  \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix02_hmm0$jb.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix02_hmm0$jb
##########################


#HRESULTS MIX 4###########

echo -e " \033[42;1;37m HResults Testando mix 4 COM TRIPHONE e TIED STATE  \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix04_hmm0$lb.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix04_hmm0$lb
##########################

#HRESULTS MIX 8###########

echo -e " \033[46;1;37m HResults Testando mix 8 COM TRIPHONE e TIED STATE  \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix08_hmm0$mb.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix08_hmm0$mb
##########################

#HRESULTS MIX 16###########

echo -e " \033[45;1;37m HResults Testando mix 16 COM TRIPHONE e TIED STATE  \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix16_hmm0$nb.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix16_hmm0$nb
##########################

#HRESULTS MIX 32###########

echo -e " \033[40;1;37m HResults Testando mix 32 COM TRIPHONE e TIED STATE  \033[0m "
./HResults -C /media/Dados/ODIN/33/HTK/htk/tidigits/confighvite -I /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/tidigits_test.mlf /media/Dados/ODIN/33/HTK/htk/tidigits/tiedlist /media/Dados/ODIN/33/HTK/htk/tidigits/mlf/recout_mix32_hmm0$ob.mlf > /media/Dados/ODIN/33/HTK/htk/tidigits/result/result_mix32_hmm0$ob

##########################


################################################# FIM HRESULTS ##########################################################################










