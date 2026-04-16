# ERP Clínico Modular (Laravel 8 + MySQL)

## 1) Estructura de carpetas propuesta

```text
app/
  Modules/
    Security/
    Configuration/
    Patients/
    Appointments/
    Admissions/
    MedicalRecords/
    Prescriptions/
    Billing/
    Inventory/
    Audit/
    Reports/
  Core/
    Exceptions/
    Traits/
    Helpers/
    Services/
  Domain/
    Shared/
      Enums/
      DTOs/
      ValueObjects/
  Http/
    Middleware/
  Providers/
```

Cada módulo incluye de base:

- `Controllers/`
- `Services/`
- `Repositories/`
- `Models/`
- `Requests/`
- `Policies/`
- `Resources/`
- `Routes/`
- `Database/Migrations/`
- `Database/Seeders/`

## 2) Flujo recomendado por capa

1. **Controller**: recibe request, autoriza, valida (FormRequest) y delega.
2. **Service**: ejecuta caso de uso, reglas de negocio y transacciones.
3. **Repository**: centraliza consultas complejas y persistencia especializada.
4. **Model**: define entidades y relaciones Eloquent.
5. **Policy**: controla permisos por acción y contexto.

## 3) Módulos principales y objetivo

- **Security**: autenticación, roles, permisos y sesiones.
- **Configuration**: clínica, sucursales, consultorios, catálogos, parámetros.
- **Patients**: ficha maestra administrativa del paciente.
- **Appointments**: agenda médica y ciclo de citas.
- **Admissions**: check-in y apertura de atención (`encounter`).
- **MedicalRecords**: historia clínica, diagnósticos, notas y signos vitales.
- **Prescriptions**: recetas y órdenes médicas.
- **Billing**: cargos, facturación, pagos y cierres de caja.
- **Inventory**: medicamentos, lotes, stock y dispensación.
- **Audit**: trazabilidad legal y operativa.
- **Reports**: consultas agregadas/tableros.

## 4) Integración sugerida en Laravel 8

- Registrar un `ModulesServiceProvider` en `config/app.php`.
- Cargar rutas por módulo desde `app/Modules/*/Routes`.
- Autoload PSR-4 para `App\Modules\` (default de `app/`).
- Mantener migraciones de módulo dentro de cada dominio y publicar/ejecutar desde un comando de consolidación.

## 5) Flujo núcleo del negocio

`Paciente -> Cita -> Admisión -> Atención -> Historia Clínica / Receta / Orden -> Factura / Pago / Dispensación -> Auditoría`

## 6) Script de base de datos

El script inicial se encuentra en:

- `database/sql/erp_clinico_laravel8_mysql.sql`

Incluye tablas núcleo para arrancar una primera versión (seguridad, pacientes, agenda, atención, historia clínica básica, prescripciones, facturación, inventario y auditoría).
