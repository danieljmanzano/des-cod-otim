# script do ph, feito para gerar plots de influências de fatores sobre as técnicas sem otimização e com tiling (alocação dinâmica e estática)

#Desabilite a linha abaixo caso o pacote ainda n�o foi instalado no sistema
#install.packages("FrF2", repos = "http://cran.rstudio.com/") # Instala o pacote

library(FrF2) # Carrega o pacote para uso

#exemplo do slide (retirado do livro do Jain)
plan.person = FrF2(nruns = 4,
                   nfactors =  2,
                   replications = 1,
                   repeat.only = FALSE,
                   factor.names = list(
                     Alocaçao_memoria = c("dinâmica", "estática"),
                     Otimizacao = c("Sem Otimização", "Tilting")),
                   randomize = FALSE)

#apresenta a configura��o do planejamento de experimentos
summary(plan.person)

#Vetor de resultados
# tempo de resposta
resultados = c(1068684, 1070146, 4919152, 4501251)

#adiciona os resultados no planejamento de experimentos
plan.atualizado = add.response(design = plan.person, response = resultados)

#apresenta a configura��o do planejamento de experimentos
summary(plan.atualizado)

#plota os gr�ficos de efeitos principais (main effects)
# https://sixsigmastudyguide.com/main-effects-plot/
MEPlot(plan.atualizado)

#plota os gr�ficos de intera��o entre as vari�veis
IAPlot(plan.atualizado)

# Modelo linear = resultados depende (~) de Rede e Acesso
plan.formula = lm(plan.atualizado$resultados~(plan.atualizado$Alocacao_memoria*plan.atualizado$Otimizacao))

# A tabela fornecida na linha abaixo diz na coluna "Estimate" os valores de q0 (m�dia), qA (Redes1), qB (Acesso1) e qAB (Redes e Acesso)
summary(plan.formula)

# C�lculo das Somas dos Quadrados
plan.anova = anova(plan.formula)

# Valores das m�dias dos quadrados podem ser observados na tabela gerada pela linha abaixo
# na coluna "Mean Sq". 
summary(plan.anova$`Mean Sq`)

# C�lculo da Soma dos Quadrados Total
SST = plan.anova$"Mean Sq"[1] + plan.anova$"Mean Sq"[2] + plan.anova$"Mean Sq"[3]

#C�lculo da influ�ncia de cada fator
InfluenciaA = plan.anova$"Mean Sq"[1] / SST
InfluenciaB = plan.anova$"Mean Sq"[2] / SST
InfluenciaAB = plan.anova$"Mean Sq"[3] / SST

cat("Influencia devido ao fator memória:", InfluenciaA)
cat("Influencia devido ao fator otimização:", InfluenciaB)
cat("Influencia devido a interação dos fatores:", InfluenciaAB)
