install.packages("readr")
library(readr)

install.packages('sqldf')
require(sqldf)


#leitura do arquivo
df = read.csv("escolas.csv", header = T)
str(df)

#alteracao dos nomes das colunas para facilitar a busca em sql
names(df) = c('Designacao', 'Nome', 'Logradouro', 'Bairro', 'Numero', 'Complemento', 'CEP', 'IDEB1', 'IDEB2', 'Latitude', 'Longitude', 'GinasioCarioca', 'Acessibilidade', 'SeriesAtendidas', 'TurnosAtendidos', 'Ginasio_olimpico', 'Diretor', 'Telefone', 'INEP', 'CoordenadorPedagogico')


####### BAIRROS COM O MAIOR NUMERO DE ESCOLAS

#obtem os bairros com suas respectivas quantidade de escolas em ordem decrescente
query = sqldf("select Bairro, count(Nome) as qtdEscolas from df group by Bairro order by qtdEscolas DESC")


#plota os 5 bairros que tem o maior numero de escolas
lab = paste(query$Bairro, query$qtdEscolas) #concatena o nome do bairro e a sua respectiva qtd de escolas
pie(query$qtdEscolas[1:5], labels = lab, main = "Numero de escolas por bairro")





####### QTD DE ESCOLAS DE PERIODO INTEGRAL NO BAIRRO CATUMBI

#faz a busca; 
#resultado == 2 escolas em tempo integral no bairro catumbi;
#como o bairro catumbi tem apenas 4 escolas, entao isso representa 50%
query2 = sqldf("select Bairro, count(Nome) as qtdEscolas_TempoIntegral from df where Bairro = 'Catumbi' and TurnosAtendidos = 'Integral'")




####### NUMERO DE COORDENADORES PEDAGOGICOS EM MAIS DE UMA ESCOLA

#faz a busca; 
#resultado == nenhum coordenador atua em mais de 1 escola e 537 escolas nao tem coordenador cadastrado
#observacao: o mesmo acontece para os diretores. 83 escolas nao tem diretore cadastrado
query3 = sqldf("select CoordenadorPedagogico, count(Nome) as qtdEscolas from df group by CoordenadorPedagogico order by qtdEscolas DESC")




###### AD HOC

#busca o nome das escolas que oferecem creche
#resultado == 460
query4 = sqldf("select Nome from df where SeriesAtendidas like '%Creche%' order by Nome")

#busca o nome das escolas que oferecem pre escola
#resultado == 714
query5 = sqldf("select Nome from df where SeriesAtendidas like '%Pré-Escola%' order by Nome")

#busca o nome das escolas que oferecem o 9 ano e que tem o IDEB1 maior que 5
#resultado == 107
query6 = sqldf("select Nome from df where SeriesAtendidas like '%9º Ano%' and IDEB1 > 5 order by Nome")


#plota um grafico de barras com os dados obtidos acima
barras = c(nrow(query4), nrow(query5), nrow(query6))
nomes = c('Creche', 'Pre-Escola', '9 Ano com IDEB > 5')
barplot(barras, legend.text = nomes, col = c('red', 'blue', 'green'),
        xlab = 'Ensino oferecido', ylab = 'Quantidade de escolas')







