# mg_pythia
madgraph docker with Pythia

#UPDATES

07.02.2020  Initial release.

08.02.2020  using Dockerfile completely.

-----------------------------------------------------------------------------------------------------------------------------------------------------

#Madgraph5 2.7.0 build on latest ubuntu with root 6.18. 

by default, only pythia8243 is installed. Other packages needed can be installed using `install PACKAGE`.

There are some artefacts and I am trying to solve them. 

Please consider following and/or contributing to the project on Github! https://github.com/Dqicool/mg_pythia
 
Recommended alia for bash like shell:
```bash
alias mg5="docker run -it --rm -u  `id -u $USER`:`id -g` -v $PWD:$PWD -w $PWD dqixol/madgraph5 mg5_aMC"
```

