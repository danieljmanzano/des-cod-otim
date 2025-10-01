# script meu. gera gráfico com tempo médio de resposta por técnica de otimização (alocação dinâmica e estática)

# se não tiver o ggplot2 instalado, remover o '#' da linha abaixo
# install.packages("ggplot2")
library(ggplot2)

# cria um dataframe com os dados coletados
dados <- data.frame(
  # coluna com o nome completo do experimento
  Experimento = c(
    "Convencional Estatico", "Convencional Dinamico",
    "Loop Interchange Estatico", "Loop Interchange Dinamico",
    "Loop Unrolling Estatico", "Loop Unrolling Dinamico",
    "Loop Tiling Estatico", "Loop Tiling Dinamico"
  ),
  # coluna separando apenas a técnica de otimização
  Tecnica = factor(c(
    "Convencional", "Convencional",
    "Loop Interchange", "Loop Interchange",
    "Loop Unrolling", "Loop Unrolling",
    "Loop Tiling", "Loop Tiling"
  ), levels = c("Convencional", "Loop Interchange", "Loop Unrolling", "Loop Tiling")), # Define a ordem no gráfico
  # coluna separando o tipo de alocação
  Alocacao = c(
    "Estática", "Dinâmica", "Estática", "Dinâmica",
    "Estática", "Dinâmica", "Estática", "Dinâmica"
  ),
  # coluna com o tempo médio de execução
  TempoMedio = c(
    8.376, 5.960, 3.6852, 4.3742, 7.784, 6.176, 4.1110, 5.092
  ),
  # coluna com a margem de erro
  MargemErro = c(
    0.224, 0.224, 0.0179, 0.0133, 0.258, 0.221, 0.0212, 0.101
  )
)

# gera o gráfico
grafico_tempo <- ggplot(dados, aes(x = Tecnica, y = TempoMedio, fill = Alocacao)) +
  # cria as barras. 'stat="identity"' usa os valores da coluna TempoMedio
  # 'position=position_dodge()' coloca as barras "Estática" e "Dinâmica" lado a lado
  geom_bar(stat = "identity", position = position_dodge()) +
  
  # adiciona as barras de erro para o intervalo de confiança
  # ymin e ymax são os limites inferior e superior do intervalo
  geom_errorbar(
    aes(ymin = TempoMedio - MargemErro, ymax = TempoMedio + MargemErro),
    width = 0.2, # largura das "hastes" da barra de erro
    position = position_dodge(0.9) # alinha as barras de erro com as barras correspondentes
  ) +
  
  # adiciona os rótulos e títulos do gráfico
  labs(
    title = "Comparação do Tempo de Resposta por Técnica de Otimização",
    subtitle = "Análise com diferentes tipos de alocação de memória (Estática vs. Dinâmica)",
    x = "Técnica de Otimização",
    y = "Tempo Médio de Resposta (segundos)",
    fill = "Tipo de Alocação" # Título da legenda
  ) +
  
  # aplica tema visual ao gráfico
  theme_minimal() +
  
  # melhora a legibilidade dos rótulos do eixo X se eles forem longos
  theme(axis.text.x = element_text(angle = 15, hjust = 1))

# exibe o gráfico
print(grafico_tempo)

# para salvar o gráfico, fazer isso manualmente com o que foi gerado na execução
# por algum motivo, quando tento salvar automático, fica num caminho errado. melhor copiar para onde quer que fique