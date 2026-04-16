// requerer o router do express
const router = require('express').Router()
// requerer o UserController
const UserController = require('../controller/UserController')

// rota para buscar perfil do usuario
router.get('/:id', UserController.getPerfil)

// rota para alterar senha
router.put('/alterar-senha', UserController.alterarSenha)

module.exports = router