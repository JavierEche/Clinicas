<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Medico extends Model
{
    protected $table = 'medicos';

    protected $fillable = [
        'usuario_id',
        'especialidad_id',
        'matricula_profesional',
        'numero_documento',
        'telefono',
        'estado',
    ];

    public const CREATED_AT = 'creado_en';
    public const UPDATED_AT = 'actualizado_en';
}
