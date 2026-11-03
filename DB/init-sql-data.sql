DELIMITER $$
-- ============================================================================
-- Seed inicial: roles
-- ----------------------------------------------------------------------------
-- Motor: SQL Server / Azure SQL (script manual, no lo ejecuta la aplicacion).
-- ============================================================================

MERGE INTO roles WITH (HOLDLOCK) AS target
USING (VALUES
    ('11111111-1111-4111-8111-000000000001', 'BOSS'),
    ('11111111-1111-4111-8111-000000000002', 'ADMIN'),
    ('11111111-1111-4111-8111-000000000003', 'BRANCH_MANAGER'),
    ('11111111-1111-4111-8111-000000000004', 'WAREHOUSE_HEAD'),
    ('11111111-1111-4111-8111-000000000005', 'ADMIN_SUPPORT')
) AS source (id, name)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET name = source.name
WHEN NOT MATCHED THEN
    INSERT (id, name)
    VALUES (source.id, source.name);

$$
