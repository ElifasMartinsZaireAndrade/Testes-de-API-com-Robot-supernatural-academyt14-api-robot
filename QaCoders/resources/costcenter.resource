*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Resource    config.resource 
Resource    auth.resource

*** Keywords ***

Cadastrar nova diretoria
    [Arguments]     ${nome_diretoria}   
    [Documentation]    Envia uma requisição POST para criar uma nova diretoria.
    ${body}=       Create Dictionary    boardName=${nome_diretoria}
    ${response}=    POST On Session
    ...             alias=supernatural
    ...             url=/board?token=${AUTH_TOKEN}
    ...             json=${body}
    ...             expected_status=any
    ${diretoria_id}=    Set Variable    ${response.json()}[newBoard][_id]
    RETURN    ${response}  ${diretoria_id}   

Cadastrar Centro de Custo
    [Arguments]    ${diretoria_id}   ${nome_cc} 
    [Documentation]    Cadastra um centro de custo com nome dinâmico. 
    ${body}=    Create Dictionary    costCenterName=${nome_cc}    boardId=${diretoria_id}
    ${response}=    POST On Session
    ...    alias=supernatural
    ...    url=/costCenter?token=${AUTH_TOKEN}
    ...    json=${body}
    ...    expected_status=any
    ${centrodecusto_id}=    Set Variable    ${response.json()}[newCostCenter][_id]
    RETURN    ${response}  ${centrodecusto_id}

Contagem de centro de custo
    [Documentation]    Envia uma requisição GET para /board/count.
    ${response}=       GET On Session
    ...                alias=supernatural
    ...                url= https://api-shogun.qacoders.dev.br/api/costCenter/count?token=${AUTH_TOKEN}    
    RETURN             ${response}
    
 Contagem com HTTP inválido
    [Documentation]    Envia uma requisição GET para /board/count.
    ${response}=       PUT On Session
    ...                alias=supernatural
    ...                url= https://api-shogun.qacoders.dev.br/api/costCenter/count?token=${AUTH_TOKEN}  
    ...                expected_status=any  
    RETURN             ${response}
    

Inativar status centro de custo
    [Arguments]    ${centrodecusto_id}    ${novo_status}
    [Documentation]    Envia uma requisição PUT para /costCenter/status/{id}.
    ${payload}=        Create Dictionary    status=${novo_status}
    ${response}=       PUT On Session
    ...                alias=supernatural
    ...                url= https://api-shogun.qacoders.dev.br/api/costCenter/status/${centrodecusto_id}?token=${AUTH_TOKEN}    
    RETURN             ${response}
    
Inativar status centro de custo id invalido
    [Documentation]    Envia uma requisição PUT para /costCenter/status/{id} com id inválido.
    ${payload}=        Create Dictionary    status=true
    ${response}=       PUT On Session
    ...                alias=supernatural
    ...                url= https://api-shogun.qacoders.dev.br/api/costCenter/status/68a7a56acec232b1ccc60731?token=${AUTH_TOKEN}  
    ...            expected_status=any 
    RETURN             ${response}
