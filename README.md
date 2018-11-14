# face_modulation
The face image modulation scripts using the osu compound facial expression

表情Aと表情Bのmorph刺激はpreparingFaceStimuli.mを使うことで作成できます．

使用する前にSHINE toolboxにPATHを通しておいてください．

The osu compound facial expression databaseをまとめたものがveg-tera2にあるのでこのスクリプトと同じディレクトリに配置してください．

The osu compound facial expression databaseの仕様などをよく読んで使用してください．

このスクリプトを使用することで表情Aと表情Bのモーフィングと輝度，顔色をL<sup>\*</sup>a<sup>\*</sup>b<sup>\*</sup>で指定でき，全刺激間で統制できる．

### スクリプト内の変数の説明
face_num は顔画像の名前のIDの番号(e.g. 01 means 01_***.jpg)
この番号については，顔データベースディレクトリにあるリストファイルを参照してください．

fe_num1, fe_num2 はモーフする表情を指定する変数です．
fe_num1はモーフ前の表情（上記の説明での表情A）
fe_num2はモーフ後の表情（上記の説明での表情B）

表情にも番号があるので，好きな表情を指定してください．
表情番号は同様にThe osu compound facial expression databaseを参考にしてください．
スクリプト内にも表情と番号の関係性は記述されています．

max_morph, min_morph はモーフレベルを指定する変数です．
max_morph-min_morphがモーフィングレベルになります．

valはLabの変調レベルを指定する (e.g. aが８，ｂが−８の場合，　[8;-8;])．
LabはLab色空間で変調する軸を指定する (e.g. abの両軸を変調したい場合，　{'a';'b';})．
