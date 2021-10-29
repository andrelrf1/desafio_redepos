class ErrorCatalog {
  static final Map<int, String> _errorList = {
    1004: 'Erro inesperado, contate o desenvolvedor. (código do erro: 1004)',
    1005: 'E-mail ou senha incorretos.',
    1007: 'Erro inesperado, contate o desenvolvedor. (código do erro: 1007)',
    1008: 'Erro inesperado, contate o desenvolvedor. (código do erro: 1008)',
    1009: 'Erro inesperado, contate o desenvolvedor. (código do erro: 1009)',
    1010: 'Erro inesperado, contate o desenvolvedor. (código do erro: 1010)',
    1012: 'Sessão expirada, faça login novamente',
    1100: 'Usuário já cadastrado.',
    1101: 'Não foi possível conectar, verifique a conexão com a internet.',
    1102: 'Erro inesperado, tente novamente!',
  };

  static String getErrorMessage(int errorCode) {
    if (_errorList.keys.toList().contains(errorCode)) {
      return _errorList[errorCode]!;
    } else {
      return 'Erro não catalogado, contate o desenvolvedor';
    }
  }
}
