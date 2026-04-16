<?php

use App\Http\Controllers\CitaMedicaController;
use App\Http\Controllers\EspecialidadController;
use App\Http\Controllers\FacturaController;
use App\Http\Controllers\MedicoController;
use App\Http\Controllers\PacienteController;
use App\Http\Controllers\PagoController;
use App\Http\Controllers\UsuarioController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return redirect()->route('usuarios.index');
});

Route::resources([
    'usuarios' => UsuarioController::class,
    'especialidades' => EspecialidadController::class,
    'medicos' => MedicoController::class,
    'pacientes' => PacienteController::class,
    'citas_medicas' => CitaMedicaController::class,
    'facturas' => FacturaController::class,
    'pagos' => PagoController::class,
]);
