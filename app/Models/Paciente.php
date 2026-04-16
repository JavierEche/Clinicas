<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Paciente extends Model
{
    protected $table = 'pacientes';

    protected $fillable = [
        'codigo_paciente',
        'nombres',
        'apellidos',
        'fecha_nacimiento',
        'sexo',
        'tipo_documento',
        'numero_documento',
        'telefono',
        'correo',
        'direccion',
        'estado',
    ];

    public const CREATED_AT = 'creado_en';
    public const UPDATED_AT = 'actualizado_en';
}
