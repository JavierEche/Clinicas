# ERP Clínico - Base de Datos MySQL

Este repositorio contiene un script SQL completo para inicializar la base de datos `erp_clinico` con una arquitectura modular orientada a un ERP clínico.

## Contenido

- Seguridad: usuarios, roles y permisos.
- Catálogos: especialidades y métodos de pago.
- Operación clínica: pacientes, médicos, citas, atenciones.
- Historia clínica inmutable con control de versiones y trazabilidad.
- Facturación y pagos.
- Auditoría de eventos y accesos a historia clínica.
- Índices y datos iniciales.
- Triggers para impedir actualización/eliminación de entradas clínicas.

## Archivo principal

- `sql/erp_clinico.sql`

## Ejecución

```bash
mysql -u tu_usuario -p < sql/erp_clinico.sql
```

## Nota de diseño

La inmutabilidad del historial clínico se soporta con:

- Restricción de `UPDATE` y `DELETE` por triggers.
- Versionado mediante `numero_version` y `entrada_anterior_id`.
- Integridad por hash con `hash_clinico`.
