# ---------------------------------------------------------------------------------
# ANÁLISE DE EXPERIMENTO FATORIAL COMPLETO 2^3 - DATASET NUT.DAT
# Adaptado para os dados de Resistência de um Componente (STRENGTH)
# ---------------------------------------------------------------------------------

# Passo 0: Carregar o pacote FrF2 (essencial para o planejamento)
# Se você já o instalou uma vez, não precisa instalar de novo.
# install.packages("FrF2")
library(FrF2)

# --- PASSO 1: CRIAÇÃO DO PLANO EXPERIMENTAL COM SEUS FATORES ---

# Definindo o planejamento 2^3 com os nomes e níveis do seu dataset.
# nruns = 8 (2^3 ensaios)
# nfactors = 3
plan_nut <- FrF2(nruns = 8,
                 nfactors = 3,
                 replications = 1,
                 randomize = FALSE, # Garante que a ordem seja a padrão (-1, +1, -1, +1...)
                 factor.names = list(
                   Preparacao_Superficie = c("Nao", "Sim"),
                   Torque_Porca = c("Baixo", "Alto"),
                   Tamanho_Porca = c("Pequeno", "Grande")
                 ))

# Mostra a tabela de planejamento, útil para conferência.
cat("--- Tabela do Plano Experimental ---\n")
print(summary(plan_nut))


# --- PASSO 2: ADICIONAR OS SEUS RESULTADOS (STRENGTH) ---

# Vetor com os 8 valores da sua variável de resposta "STRENGTH",
# na ordem exata em que foram fornecidos.
STRENGTH <- c(130, 80, 118, 93, 86, 105, 76, 124)


# Adiciona a coluna de resultados ao nosso plano experimental
plan_atualizado <- add.response(design = plan_nut, response = STRENGTH)

# Apresenta a tabela final, agora com a coluna "STRENGTH"
cat("\n--- Tabela do Plano com os Resultados (STRENGTH) ---\n")
print(plan_atualizado)


# --- PASSO 3: ANÁLISE GRÁFICA DOS EFEITOS ---

# Plota os gráficos de efeitos principais.
# Linhas mais inclinadas indicam fatores mais influentes.
cat("\n--- Gerando Gráfico de Efeitos Principais... ---\n")
MEPlot(plan_atualizado)

# Plota os gráficos de interação.
# Linhas que não são paralelas sugerem uma interação.
cat("--- Gerando Gráfico de Interações... ---\n")
IAPlot(plan_atualizado)


# --- PASSO 4: MODELO MATEMÁTICO E ANOVA ---

# Cria um modelo linear para estimar os efeitos de cada fator e interação.
modelo_linear <- lm(STRENGTH ~ Preparacao_Superficie * Torque_Porca * Tamanho_Porca, data = plan_atualizado)

# Mostra os coeficientes do modelo
cat("\n--- Resumo do Modelo Linear ---\n")
print(summary(modelo_linear))


# --- PASSO 5: CÁLCULO DA INFLUÊNCIA PERCENTUAL DE CADA FATOR ---

# A Análise de Variância (ANOVA) decompõe a variação total dos dados.
analise_anova <- anova(modelo_linear)

cat("\n--- Tabela ANOVA ---\n")
print(analise_anova)

# A coluna "Sum Sq" (Soma dos Quadrados) é a chave aqui.
# Ela nos diz quanta da variação na RESISTÊNCIA é explicada por cada fator.

# Calculamos a Soma dos Quadrados Total (SST)
SST <- sum(analise_anova$"Sum Sq")

# Calculamos a influência percentual de cada componente
influencia_A  <- analise_anova$"Sum Sq"[1] / SST # Preparacao_Superficie
influencia_B  <- analise_anova$"Sum Sq"[2] / SST # Torque_Porca
influencia_C  <- analise_anova$"Sum Sq"[3] / SST # Tamanho_Porca
influencia_AB <- analise_anova$"Sum Sq"[4] / SST # Interação A:B
influencia_AC <- analise_anova$"Sum Sq"[5] / SST # Interação A:C
influencia_BC <- analise_anova$"Sum Sq"[6] / SST # Interação B:C
influencia_ABC<- analise_anova$"Sum Sq"[7] / SST # Interação A:B:C

# Apresentamos o resultado final, que é o objetivo do exercício!
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