# análise de experimento fatorial completo 2^3 - dataset NUT.DAT

# install.packages("FrF2") # descomenta aqui pra baixar
library(FrF2)

# criação do plano experimental e os fatores -----------------------------------
# nruns = 8 (2^3 ensaios)
# nfactors = 3
plan_nut <- FrF2(nruns = 8,
                 nfactors = 3,
                 replications = 1,
                 randomize = FALSE, # mantém a ordem padrão (-1, +1, -1, +1...)
                 factor.names = list(
                   Preparacao_Superficie = c("Nao", "Sim"),
                   Torque_Porca = c("Baixo", "Alto"),
                   Tamanho_Porca = c("Pequeno", "Grande")
                 ))


# adição de resultados ---------------------------------------------------------
# vetor com os 8 valores de "STRENGTH" (na ordem correta)
STRENGTH <- c(130, 80, 118, 93, 86, 105, 76, 124)

# adiciona a coluna de resultados ao plano experimental
plan_atualizado <- add.response(design = plan_nut, response = STRENGTH)

# apresenta a tabela final com a coluna "STRENGTH"
cat("\n--- Tabela do Plano com os Resultados (STRENGTH) ---\n")
print(plan_atualizado)


# análise gráfica dos efeitos --------------------------------------------------
cat("\n--- Gerando Gráfico de Efeitos Principais... ---\n")
MEPlot(plan_atualizado)

# plota os gráficos de interação
cat("--- Gerando Gráfico de Interações... ---\n")
IAPlot(plan_atualizado)


# modelo matemático e resultados -----------------------------------------------
# cria um modelo linear para estimar os efeitos de cada fator e interação
modelo_linear <- lm(STRENGTH ~ Preparacao_Superficie * Torque_Porca * 
                    Tamanho_Porca, data = plan_atualizado)

# mostra os coeficientes do modelo
cat("\n--- Resumo do Modelo Linear ---\n")
print(summary(modelo_linear))

# a "análise de variância" (ANOVA) decompõe a variação total dos dados
analise_anova <- anova(modelo_linear)

cat("\n--- Tabela ANOVA ---\n")
print(analise_anova)

# calcula a "soma dos quadrados total" (SST)
SST <- sum(analise_anova$"Sum Sq")

# calcula a influência percentual de cada componente
influencia_A  <- analise_anova$"Sum Sq"[1] / SST # Preparacao_Superficie
influencia_B  <- analise_anova$"Sum Sq"[2] / SST # Torque_Porca
influencia_C  <- analise_anova$"Sum Sq"[3] / SST # Tamanho_Porca
influencia_AB <- analise_anova$"Sum Sq"[4] / SST # interação A:B
influencia_AC <- analise_anova$"Sum Sq"[5] / SST # interação A:C
influencia_BC <- analise_anova$"Sum Sq"[6] / SST # interação B:C
influencia_ABC<- analise_anova$"Sum Sq"[7] / SST # interação A:B:C

# resultado final
cat("\n--- INFLUÊNCIA PERCENTUAL NA RESISTÊNCIA DO COMPONENTE ---\n")
cat(sprintf("Fator A (Prep. Superfície): %.2f%%\n", influencia_A * 100))
cat(sprintf("Fator B (Torque da Porca):  %.2f%%\n", influencia_B * 100))
cat(sprintf("Fator C (Tamanho da Porca): %.2f%%\n", influencia_C * 100))
cat(sprintf("Interação A:B:              %.2f%%\n", influencia_AB * 100))
cat(sprintf("Interação A:C:              %.2f%%\n", influencia_AC * 100))
cat(sprintf("Interação B:C:              %.2f%%\n", influencia_BC * 100))
cat(sprintf("Interação A:B:C:            %.2f%%\n", influencia_ABC * 100))

soma_total <- sum(analise_anova$"Sum Sq") / SST
cat(sprintf("\nSoma total das influências: %.2f%%\n", soma_total * 100))