*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         String

Resource        ../resources/config.resource
Resource        ../resources/auth.resource
Resource        ../resources/costcenter.resource

Test Setup      Realizar Login e Salvar Token

*** Test Cases ***
# ==================================================================================================
#            --- Cadastro de Centro de Custo ---
# ==================================================================================================
CT01: Cadastro de Centro de Custo com sucesso
    [Documentation]    Cria uma diretoria e um centro de custo, encadeando o ID.
    ${nome_diretoria_aleatorio}=    Generate Random String    10    [LOWER]
    ${resp_diretoria}    ${diretoria_id}=    Cadastrar nova diretoria      E${nome_diretoria_aleatorio}
    Status Should Be    201    ${resp_diretoria}
    Dictionary Should Contain Key    ${resp_diretoria.json()}[newBoard]    _id
    ${nome_cc}=    Generate Random String    10    [LOWER]
    ${body}=    Create Dictionary    costCenterName=${nome_cc}    boardId=${diretoria_id}
    ${resp_cc}   ${centro_custo_id}=  Cadastrar Centro de Custo    ${diretoria_id}  E${nome_cc}
    Status Should Be    201    ${resp_cc}
    Should Contain    ${resp_cc.content}    ${diretoria_id}

# ==================================================================================================
#            --- Contagem Centro de Custo ---
# ==================================================================================================
CT02: Contagem do centro de custo sucesso
    [Documentation]    Realiza a contagem de centro de custo.
    Contagem de centro de custo
    Status Should Be   200    

CT03: Contagem utilizando HTTP inválido
    [Documentation]    Realiza a contagem de centro de custo utilizando HTTP inválido.
    ${response}=        Contagem com HTTP inválido  
    Status Should Be     400     ${response}
    Should Contain       ${response.json()}[error][0]    O campo 'centro de custos' é obrigatório.
    
# ==================================================================================================
#           Inativar centro de custo pelo ID
# ==================================================================================================

CT04: Inativar status do centro de custo
    [Documentation]    Cria uma diretoria e um centro de custo, encadeando o ID. Depois inativa o centro de custo.
    ${nome_diretoria}=    Generate Random String    10    [LOWER]
    ${resp_diretoria}    ${diretoria_id}=    Cadastrar nova diretoria      E${nome_diretoria}
    Status Should Be    201    ${resp_diretoria}
    Dictionary Should Contain Key    ${resp_diretoria.json()}[newBoard]    _id
    ${nome_cc}=    Generate Random String    10    [LOWER]
    ${body}=    Create Dictionary    costCenterName=${nome_cc}    boardId=${diretoria_id}
    ${resp_cc}  ${centrodecusto_id}=    Cadastrar Centro de Custo    ${diretoria_id}  E${nome_cc}
    Status Should Be    201    ${resp_cc}
    Should Contain    ${resp_cc.content}    ${diretoria_id}
    ${resp_inativacao}=    Inativar status centro de custo    ${centrodecusto_id}    false
    Status Should Be     202  
    Should Contain       ${resp_inativacao.json()}[msg]    Centro de custos inativado com sucesso!

CT05: Atualizar status do centro de custo com id invalido
    [Documentation]    Tenta inativar um centro de custo com ID inválido.
    ${response}=  Inativar status centro de custo id invalido
    Status Should Be     404
    Should Contain       ${response.json()}[msg]    Não foi possível encontrar a centro de custos com o id especificado
