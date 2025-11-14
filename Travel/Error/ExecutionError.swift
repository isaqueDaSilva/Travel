//
//  ExecutionError.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import Foundation

/// Representation of a error when some failure occur processing a request.
struct ExecutionError: Sendable, Error {
    /// User-friendly error title.
    let title: String
    
    /// A unique code representation of a error.
    let errorCode: String
    
    /// Description of what's failed when a request was processed.
    let errorDescription: String
    
    init(title: String, errorDescription: String) {
        self.title = title
        self.errorCode = title
        self.errorDescription = errorDescription
    }
}

// MARK: - Decoding -
extension ExecutionError: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorDescription = "error_description"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = "Falha no processo."
        self.errorCode = try container.decode(String.self, forKey: .errorCode)
        self.errorDescription = try container.decode(String.self, forKey: .errorDescription)
    }
}

// TODO: Verify defaults erros and identify which error message is necessary
// MARK: - Default Errors -
extension ExecutionError {
    static let badURL = ExecutionError(
        title: "URL não reconhecida.",
        errorDescription: "A URL fornecida está valida para utilização. Por favor tente novamente, ou se o erro persistir, entre em contato conosco."
    )
    
    static let encodeError = ExecutionError(
        title: "Erro no envio dos dados",
        errorDescription: "Não foi possivel tranformar os dados fornecidos no formato esperado para enviar para nossos servidores e processar sus requisição. Por favor tente novamente ou entre em contato conosco."
    )
    
    static let executionError = ExecutionError(
        title: "Erro de envio dos dados",
        errorDescription: "Parece que houve um erro ao enviar sua requisição para nossos servidores. Por favor tente novamente, ou se o erro persistir entre em contato conosco."
    )
    
    static let badResponse = ExecutionError(
        title: "Resposta invalida.",
        errorDescription: "Parece que o servidor devolveu uma resposta insesperada. Por favor tente repetir novamente o processo ou se o erro persistir informe-nos para que possamos solucionar o problema."
    )
    
    static let unknownError = ExecutionError(
        title: "Erro não identificado",
        errorDescription: "Parece que a execução do processo gerou um erro não identificado. Por favor tente novamente repetir o processo ou entre em contato conosco caso o erro se repita."
    )
    
    static let decodeError = ExecutionError(
        title: "Erro na leitura dos dados recebidos",
        errorDescription: "Ocorreu um erro ao transformar os dados recebidos em um formato legivel pelo app. Por favor tente novamente repetir o processo ou informe-nos caso o erro persista."
    )
}
