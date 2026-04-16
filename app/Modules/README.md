# Estructura modular base (Laravel 8)

Se creó el esqueleto inicial de módulos:

- Security
- Configuration
- Patients
- Appointments
- Admissions
- MedicalRecords
- Prescriptions
- Billing
- Inventory
- Audit
- Reports

Cada módulo incluye las carpetas:

- Controllers
- Services
- Repositories
- Models
- Requests
- Policies
- Resources
- Routes
- Database/Migrations
- Database/Seeders

Las carpetas compartidas para soporte arquitectónico también fueron creadas en:

- `app/Core/*`
- `app/Domain/Shared/*`
- `app/Http/Middleware`
- `app/Providers`
