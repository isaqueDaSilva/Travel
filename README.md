# Table of Contents
1. [Getting started](#getting-started)
2. [Structure](#structure)
3. [Tests](#tests)
4. [Design](#design)
5. [API](#api)

# Travel
Um projeto conceito iOS, desenvolvido em Swift e SwiftUI, com foco em conectar motoristas a usuários que desejam uma corrida. 

# Getting started
Antes de começar, siga os passos abaixo:
<p>
* Verifique se você está usando o Xcode 16, com o simulador no iOS 18<br>
* Baixe este repositório.<br>
* Abra o projeto.<br>
* Compile e execute o app.<br>

Após a compilação, e o app estando executando normalmente, você deve ver um formulário para inserir as informações do trajeto e sua identificação.<br>

# Structure
* O Travel utiliza o padrão de arquitetura <strong>Model-View-ViewModel (MVVM)</strong><br>
* O Model é responsável por lidar apenas com os dados necessários para do app.<br>
* A View é responsável apenas por exibir o estado atual em que os dados se encontram.<br>
* A ViewModel é responsável por criar uma ponte entre o Model e a View, e processar informações e ações.<br>
* O Helper, é um conjunto de métodos padrões que auxilia a execução de algum processo, sem a necessidade de duplicação de código.<br>
* A camada de Network, é um conjunto de métodos que são responsáveis por lidar com a comunicação entre o App e a API.<br>

# Tests
O Travel possuí um conjunto de testes unitários, para verificar se as funcionálidades do App estão funcionando corretamente.<br>
Se você desejar analisa-los ou mesmo executa-lo, basta ir para a pasta <strong>TravelTests</strong>, navegar para alguma subpasta marcada com <strong>Test</strong> no final, analisa-la e/ou executar os testes.

# Design 
O App foi pensado para ser simples, intuitivo e familiar para os usuários do iOS. Portanto se design foi inspirado nos Apps padrões do iOS, com forte uso de componentes padrões do sistema como o Form e o Apple Maps(Na tela para escolha de um motorista.).<br>
Além de uso de cores padrões em toda UI para evitar fadiga visual e dificuldade ao encontrar algum componente.

# API 
O app faz uma requisição a uma API no qual é responsável por fazer o calculo da rota das viagens, confirmação de viagem, e obter o histórico de viagens do passageiro com um determinado motorista.
