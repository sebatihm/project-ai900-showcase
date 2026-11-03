DELIMITER $$
-- ============================================================================
-- Datos de prueba para Project AI-901
-- ----------------------------------------------------------------------------
-- Motor: SQL Server / Azure SQL
-- Base de datos: project_ai901
--
-- Incluye: branches, warehouses, categories, products, suppliers, inventory,
--          customers, orders, order_items, tickets y ticket_messages.
-- ============================================================================

SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ----------------------------------------------------------------------------
-- Sucursales
-- ----------------------------------------------------------------------------
MERGE INTO branches WITH (HOLDLOCK) AS target
USING (VALUES
    ('33333333-3333-4333-8333-000000000001', 'TST-CDMX', 'Sucursal TST Centro CDMX', 'Ciudad de México', 1),
    ('33333333-3333-4333-8333-000000000002', 'TST-GDL', 'Sucursal TST Guadalajara', 'Guadalajara', 1),
    ('33333333-3333-4333-8333-000000000003', 'TST-MTY', 'Sucursal TST Monterrey', 'Monterrey', 1),
    ('33333333-3333-4333-8333-000000000004', 'TST-QRO', 'Sucursal TST Querétaro', 'Querétaro', 1),
    ('33333333-3333-4333-8333-000000000005', 'TST-TOL', 'Sucursal TST Toluca', 'Toluca', 0)
) AS source (id, code, name, city, active)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        code = source.code,
        name = source.name,
        city = source.city,
        active = source.active
WHEN NOT MATCHED THEN
    INSERT (id, code, name, city, active)
    VALUES (source.id, source.code, source.name, source.city, source.active);

-- ----------------------------------------------------------------------------
-- Almacenes
-- ----------------------------------------------------------------------------
MERGE INTO warehouses WITH (HOLDLOCK) AS target
USING (VALUES
    ('44444444-4444-4444-8444-000000000001', 'TST-ALM-CDMX1', 'Almacén TST CDMX Centro', 1, '33333333-3333-4333-8333-000000000001'),
    ('44444444-4444-4444-8444-000000000002', 'TST-ALM-CDMX2', 'Almacén TST CDMX Norte', 1, '33333333-3333-4333-8333-000000000001'),
    ('44444444-4444-4444-8444-000000000003', 'TST-ALM-GDL1', 'Almacén TST Guadalajara', 1, '33333333-3333-4333-8333-000000000002'),
    ('44444444-4444-4444-8444-000000000004', 'TST-ALM-MTY1', 'Almacén TST Monterrey', 1, '33333333-3333-4333-8333-000000000003'),
    ('44444444-4444-4444-8444-000000000005', 'TST-ALM-QRO1', 'Almacén TST Querétaro', 1, '33333333-3333-4333-8333-000000000004'),
    ('44444444-4444-4444-8444-000000000006', 'TST-ALM-QRO2', 'Almacén TST Querétaro Norte', 0, '33333333-3333-4333-8333-000000000004')
) AS source (id, code, name, active, branch_id)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        code = source.code,
        name = source.name,
        active = source.active,
        branch_id = source.branch_id
WHEN NOT MATCHED THEN
    INSERT (id, code, name, active, branch_id)
    VALUES (source.id, source.code, source.name, source.active, source.branch_id);

-- ----------------------------------------------------------------------------
-- Categorías
-- ----------------------------------------------------------------------------
MERGE INTO categories WITH (HOLDLOCK) AS target
USING (VALUES
    ('55555555-5555-4555-8555-000000000001', 'TST Limpieza de superficies'),
    ('55555555-5555-4555-8555-000000000002', 'TST Desinfectantes y sanitizantes'),
    ('55555555-5555-4555-8555-000000000003', 'TST Papel e higiene'),
    ('55555555-5555-4555-8555-000000000004', 'TST Químicos industriales'),
    ('55555555-5555-4555-8555-000000000005', 'TST Accesorios de limpieza'),
    ('55555555-5555-4555-8555-000000000006', 'TST Bolsas y desechables')
) AS source (id, name)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET name = source.name
WHEN NOT MATCHED THEN
    INSERT (id, name)
    VALUES (source.id, source.name);

-- ----------------------------------------------------------------------------
-- Productos
-- ----------------------------------------------------------------------------
MERGE INTO products WITH (HOLDLOCK) AS target
USING (VALUES
    ('66666666-6666-4666-8666-000000000001', 'TST-LIM-MUL-LAV-1L', 'Limpiador multiusos lavanda 1L', '55555555-5555-4555-8555-000000000001', 'botella', 38.50),
    ('66666666-6666-4666-8666-000000000002', 'TST-LIM-DES-COC-1L', 'Limpiador desengrasante cocina 1L', '55555555-5555-4555-8555-000000000001', 'botella', 52.00),
    ('66666666-6666-4666-8666-000000000003', 'TST-LIM-PIS-PIN-4L', 'Limpiador de pisos aroma pino 4L', '55555555-5555-4555-8555-000000000001', 'galón', 89.90),
    ('66666666-6666-4666-8666-000000000004', 'TST-LIM-BAN-CLO-1L', 'Limpiador de baños con cloro 1L', '55555555-5555-4555-8555-000000000001', 'botella', 45.00),
    ('66666666-6666-4666-8666-000000000005', 'TST-DES-MUL-1L', 'Desinfectante multiusos 1L', '55555555-5555-4555-8555-000000000002', 'botella', 64.00),
    ('66666666-6666-4666-8666-000000000006', 'TST-SAN-ALI-4L', 'Sanitizante para alimentos 4L', '55555555-5555-4555-8555-000000000002', 'galón', 145.00),
    ('66666666-6666-4666-8666-000000000007', 'TST-ALI-ETI-70-1L', 'Alcohol etílico 70% 1L', '55555555-5555-4555-8555-000000000002', 'botella', 58.00),
    ('66666666-6666-4666-8666-000000000008', 'TST-CLO-CON-4L', 'Cloro concentrado 4L', '55555555-5555-4555-8555-000000000002', 'galón', 72.00),
    ('66666666-6666-4666-8666-000000000009', 'TST-PAP-HIG-12', 'Papel higiénico institucional 12 rollos', '55555555-5555-4555-8555-000000000003', 'paquete', 98.00),
    ('66666666-6666-4666-8666-000000000010', 'TST-TOA-PAP-20', 'Toalla de papel interfoliada 20 paquetes', '55555555-5555-4555-8555-000000000003', 'caja', 210.00),
    ('66666666-6666-4666-8666-000000000011', 'TST-JAB-LIQ-1L', 'Jabón líquido para manos 1L', '55555555-5555-4555-8555-000000000003', 'botella', 49.50),
    ('66666666-6666-4666-8666-000000000012', 'TST-GEL-ANT-500', 'Gel antibacterial 500 ml', '55555555-5555-4555-8555-000000000003', 'botella', 55.00),
    ('66666666-6666-4666-8666-000000000013', 'TST-DET-IND-5L', 'Detergente industrial 5L', '55555555-5555-4555-8555-000000000004', 'cubeta', 320.00),
    ('66666666-6666-4666-8666-000000000014', 'TST-DES-INC-4L', 'Desincrustante para pisos 4L', '55555555-5555-4555-8555-000000000004', 'galón', 185.00),
    ('66666666-6666-4666-8666-000000000015', 'TST-CER-LIQ-4L', 'Cera líquida para pisos 4L', '55555555-5555-4555-8555-000000000004', 'galón', 165.00),
    ('66666666-6666-4666-8666-000000000016', 'TST-NEU-OLO-1L', 'Neutralizador de olores 1L', '55555555-5555-4555-8555-000000000004', 'botella', 78.00),
    ('66666666-6666-4666-8666-000000000017', 'TST-FIB-MUL-10', 'Fibra multiusos 10 piezas', '55555555-5555-4555-8555-000000000005', 'paquete', 35.00),
    ('66666666-6666-4666-8666-000000000018', 'TST-ESC-IND-01', 'Escoba industrial', '55555555-5555-4555-8555-000000000005', 'pieza', 120.00),
    ('66666666-6666-4666-8666-000000000019', 'TST-TRA-MOP-400', 'Trapeador mopa 400 g', '55555555-5555-4555-8555-000000000005', 'pieza', 95.00),
    ('66666666-6666-4666-8666-000000000020', 'TST-GUA-NIT-100', 'Guantes de nitrilo caja 100', '55555555-5555-4555-8555-000000000005', 'caja', 180.00),
    ('66666666-6666-4666-8666-000000000021', 'TST-BOL-BAS-8010', 'Bolsa de basura 80x100 cm 10 piezas', '55555555-5555-4555-8555-000000000006', 'paquete', 60.00),
    ('66666666-6666-4666-8666-000000000022', 'TST-BOL-BAS-6010', 'Bolsa de basura 60x80 cm 10 piezas', '55555555-5555-4555-8555-000000000006', 'paquete', 45.00),
    ('66666666-6666-4666-8666-000000000023', 'TST-CUB-TRI-50', 'Cubrebocas tricapa caja 50', '55555555-5555-4555-8555-000000000006', 'caja', 70.00),
    ('66666666-6666-4666-8666-000000000024', 'TST-SER-INS-500', 'Servilleta institucional 500 piezas', '55555555-5555-4555-8555-000000000006', 'paquete', 85.00)
) AS source (id, sku, name, category_id, unit, price)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        sku = source.sku,
        name = source.name,
        category_id = source.category_id,
        unit = source.unit,
        price = source.price
WHEN NOT MATCHED THEN
    INSERT (id, sku, name, category_id, unit, price)
    VALUES (source.id, source.sku, source.name, source.category_id, source.unit, source.price);

-- ----------------------------------------------------------------------------
-- Proveedores
-- ----------------------------------------------------------------------------
MERGE INTO suppliers WITH (HOLDLOCK) AS target
USING (VALUES
    ('77777777-7777-4777-8777-000000000001', 'Distribuidora Delta SA de CV', 'TST850101AB1', 'ventas@delta.example.test'),
    ('77777777-7777-4777-8777-000000000002', 'Química del Norte SA de CV', 'TST920215CD2', 'contacto@quimicanorte.example.test'),
    ('77777777-7777-4777-8777-000000000003', 'Envases y Empaques Ríos SA de CV', 'TST010420EF3', 'pedidos@empaquesrios.example.test'),
    ('77777777-7777-4777-8777-000000000004', 'Suministros Industriales MX SA de CV', 'TST050610GH4', 'ventas@simx.example.test'),
    ('77777777-7777-4777-8777-000000000005', 'Comercializadora Azteca SA de CV', 'TST880915IJ5', 'clientes@azteca.example.test')
) AS source (id, name, rfc, email)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        name = source.name,
        rfc = source.rfc,
        email = source.email
WHEN NOT MATCHED THEN
    INSERT (id, name, rfc, email)
    VALUES (source.id, source.name, source.rfc, source.email);

-- ----------------------------------------------------------------------------
-- Inventario
-- ----------------------------------------------------------------------------
MERGE INTO inventory WITH (HOLDLOCK) AS target
USING (VALUES
    ('88888888-8888-4888-8888-000000000001', '44444444-4444-4444-8444-000000000001', '66666666-6666-4666-8666-000000000001', 120, 0),
    ('88888888-8888-4888-8888-000000000002', '44444444-4444-4444-8444-000000000001', '66666666-6666-4666-8666-000000000005', 80, 0),
    ('88888888-8888-4888-8888-000000000003', '44444444-4444-4444-8444-000000000001', '66666666-6666-4666-8666-000000000009', 45, 0),
    ('88888888-8888-4888-8888-000000000004', '44444444-4444-4444-8444-000000000001', '66666666-6666-4666-8666-000000000013', 15, 0),
    ('88888888-8888-4888-8888-000000000005', '44444444-4444-4444-8444-000000000001', '66666666-6666-4666-8666-000000000017', 0, 0),
    ('88888888-8888-4888-8888-000000000006', '44444444-4444-4444-8444-000000000001', '66666666-6666-4666-8666-000000000021', 60, 0),
    ('88888888-8888-4888-8888-000000000007', '44444444-4444-4444-8444-000000000002', '66666666-6666-4666-8666-000000000002', 90, 0),
    ('88888888-8888-4888-8888-000000000008', '44444444-4444-4444-8444-000000000002', '66666666-6666-4666-8666-000000000006', 35, 0),
    ('88888888-8888-4888-8888-000000000009', '44444444-4444-4444-8444-000000000002', '66666666-6666-4666-8666-000000000010', 20, 0),
    ('88888888-8888-4888-8888-000000000010', '44444444-4444-4444-8444-000000000002', '66666666-6666-4666-8666-000000000014', 8, 0),
    ('88888888-8888-4888-8888-000000000011', '44444444-4444-4444-8444-000000000002', '66666666-6666-4666-8666-000000000018', 12, 0),
    ('88888888-8888-4888-8888-000000000012', '44444444-4444-4444-8444-000000000002', '66666666-6666-4666-8666-000000000022', 0, 0),
    ('88888888-8888-4888-8888-000000000013', '44444444-4444-4444-8444-000000000003', '66666666-6666-4666-8666-000000000003', 70, 0),
    ('88888888-8888-4888-8888-000000000014', '44444444-4444-4444-8444-000000000003', '66666666-6666-4666-8666-000000000007', 110, 0),
    ('88888888-8888-4888-8888-000000000015', '44444444-4444-4444-8444-000000000003', '66666666-6666-4666-8666-000000000011', 65, 0),
    ('88888888-8888-4888-8888-000000000016', '44444444-4444-4444-8444-000000000003', '66666666-6666-4666-8666-000000000015', 9, 0),
    ('88888888-8888-4888-8888-000000000017', '44444444-4444-4444-8444-000000000003', '66666666-6666-4666-8666-000000000019', 25, 0),
    ('88888888-8888-4888-8888-000000000018', '44444444-4444-4444-8444-000000000003', '66666666-6666-4666-8666-000000000023', 40, 0),
    ('88888888-8888-4888-8888-000000000019', '44444444-4444-4444-8444-000000000004', '66666666-6666-4666-8666-000000000004', 85, 0),
    ('88888888-8888-4888-8888-000000000020', '44444444-4444-4444-8444-000000000004', '66666666-6666-4666-8666-000000000008', 50, 0),
    ('88888888-8888-4888-8888-000000000021', '44444444-4444-4444-8444-000000000004', '66666666-6666-4666-8666-000000000012', 75, 0),
    ('88888888-8888-4888-8888-000000000022', '44444444-4444-4444-8444-000000000004', '66666666-6666-4666-8666-000000000016', 5, 0),
    ('88888888-8888-4888-8888-000000000023', '44444444-4444-4444-8444-000000000004', '66666666-6666-4666-8666-000000000020', 18, 0),
    ('88888888-8888-4888-8888-000000000024', '44444444-4444-4444-8444-000000000004', '66666666-6666-4666-8666-000000000024', 30, 0),
    ('88888888-8888-4888-8888-000000000025', '44444444-4444-4444-8444-000000000005', '66666666-6666-4666-8666-000000000001', 60, 0),
    ('88888888-8888-4888-8888-000000000026', '44444444-4444-4444-8444-000000000005', '66666666-6666-4666-8666-000000000009', 40, 0),
    ('88888888-8888-4888-8888-000000000027', '44444444-4444-4444-8444-000000000005', '66666666-6666-4666-8666-000000000013', 12, 0),
    ('88888888-8888-4888-8888-000000000028', '44444444-4444-4444-8444-000000000005', '66666666-6666-4666-8666-000000000017', 6, 0),
    ('88888888-8888-4888-8888-000000000029', '44444444-4444-4444-8444-000000000005', '66666666-6666-4666-8666-000000000021', 55, 0),
    ('88888888-8888-4888-8888-000000000030', '44444444-4444-4444-8444-000000000005', '66666666-6666-4666-8666-000000000024', 0, 0)
) AS source (id, warehouse_id, product_id, quantity, version)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        warehouse_id = source.warehouse_id,
        product_id = source.product_id,
        quantity = source.quantity,
        version = source.version
WHEN NOT MATCHED THEN
    INSERT (id, warehouse_id, product_id, quantity, version)
    VALUES (source.id, source.warehouse_id, source.product_id, source.quantity, source.version);

-- ----------------------------------------------------------------------------
-- Clientes
-- ----------------------------------------------------------------------------
MERGE INTO customers WITH (HOLDLOCK) AS target
USING (VALUES
    ('99999999-9999-4999-8999-000000000001', 'Hotel Casa Blanca', 'HOTEL', 'reservas@casablanca.example.test', '5551001001', '33333333-3333-4333-8333-000000000001'),
    ('99999999-9999-4999-8999-000000000002', 'Hotel Real del Valle', 'HOTEL', 'compras@realdelvalle.example.test', '5551001002', '33333333-3333-4333-8333-000000000001'),
    ('99999999-9999-4999-8999-000000000003', 'Hotel Plaza Guadalajara', 'HOTEL', 'admin@plazagdl.example.test', '3331002001', '33333333-3333-4333-8333-000000000002'),
    ('99999999-9999-4999-8999-000000000004', 'Escuela Primaria Benito Juárez', 'SCHOOL', 'direccion@benitojuarez.example.test', '5551003001', '33333333-3333-4333-8333-000000000001'),
    ('99999999-9999-4999-8999-000000000005', 'Colegio San Ángel', 'SCHOOL', 'servicios@sanangel.example.test', '5551003002', '33333333-3333-4333-8333-000000000004'),
    ('99999999-9999-4999-8999-000000000006', 'Instituto Tecnológico del Norte', 'SCHOOL', 'mantenimiento@itn.example.test', '8181004001', '33333333-3333-4333-8333-000000000003'),
    ('99999999-9999-4999-8999-000000000007', 'Tienda La Esquina', 'STORE', NULL, '5551005001', '33333333-3333-4333-8333-000000000001'),
    ('99999999-9999-4999-8999-000000000008', 'Supermercado El Ahorro', 'STORE', 'compras@elahorro.example.test', NULL, '33333333-3333-4333-8333-000000000002'),
    ('99999999-9999-4999-8999-000000000009', 'Abarrotes y Limpieza Querétaro', 'STORE', 'pedidos@alq.example.test', '4421006001', '33333333-3333-4333-8333-000000000004'),
    ('99999999-9999-4999-8999-000000000010', 'Comercializadora Bajío', 'STORE', 'contacto@bajio.example.test', '4421006002', NULL)
) AS source (id, name, type, email, phone, branch_id)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        name = source.name,
        type = source.type,
        email = source.email,
        phone = source.phone,
        branch_id = source.branch_id
WHEN NOT MATCHED THEN
    INSERT (id, name, type, email, phone, branch_id)
    VALUES (source.id, source.name, source.type, source.email, source.phone, source.branch_id);

-- ----------------------------------------------------------------------------
-- Órdenes
-- ----------------------------------------------------------------------------
MERGE INTO orders WITH (HOLDLOCK) AS target
USING (VALUES
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000001', 'TST-ORD-20260901-0001', '99999999-9999-4999-8999-000000000001', '33333333-3333-4333-8333-000000000001', CAST(NULL AS uniqueidentifier), 'DELIVERED', '2026-09-01 10:15:00', '2026-09-03', 2344.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000002', 'TST-ORD-20260903-0002', '99999999-9999-4999-8999-000000000004', '33333333-3333-4333-8333-000000000001', CAST(NULL AS uniqueidentifier), 'DELIVERED', '2026-09-03 11:30:00', '2026-09-05', 2260.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000003', 'TST-ORD-20260905-0003', '99999999-9999-4999-8999-000000000007', '33333333-3333-4333-8333-000000000001', CAST(NULL AS uniqueidentifier), 'SHIPPED', '2026-09-05 09:00:00', '2026-09-08', 2844.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000004', 'TST-ORD-20260907-0004', '99999999-9999-4999-8999-000000000002', '33333333-3333-4333-8333-000000000001', CAST(NULL AS uniqueidentifier), 'PREPARING', '2026-09-07 16:45:00', '2026-09-10', 1892.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000005', 'TST-ORD-20260909-0005', '99999999-9999-4999-8999-000000000003', '33333333-3333-4333-8333-000000000002', CAST(NULL AS uniqueidentifier), 'DELIVERED', '2026-09-09 08:20:00', '2026-09-11', 2828.50),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000006', 'TST-ORD-20260911-0006', '99999999-9999-4999-8999-000000000008', '33333333-3333-4333-8333-000000000002', CAST(NULL AS uniqueidentifier), 'RECEIVED', '2026-09-11 13:10:00', '2026-09-15', 2925.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000007', 'TST-ORD-20260913-0007', '99999999-9999-4999-8999-000000000006', '33333333-3333-4333-8333-000000000003', CAST(NULL AS uniqueidentifier), 'SHIPPED', '2026-09-13 10:00:00', '2026-09-16', 3160.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000008', 'TST-ORD-20260915-0008', '99999999-9999-4999-8999-000000000005', '33333333-3333-4333-8333-000000000004', CAST(NULL AS uniqueidentifier), 'DELIVERED', '2026-09-15 15:30:00', '2026-09-18', 2525.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000009', 'TST-ORD-20260917-0009', '99999999-9999-4999-8999-000000000009', '33333333-3333-4333-8333-000000000004', CAST(NULL AS uniqueidentifier), 'PREPARING', '2026-09-17 09:45:00', '2026-09-20', 3144.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000010', 'TST-ORD-20260919-0010', '99999999-9999-4999-8999-000000000010', '33333333-3333-4333-8333-000000000004', CAST(NULL AS uniqueidentifier), 'CANCELED', '2026-09-19 12:00:00', '2026-09-22', 1075.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000011', 'TST-ORD-20260921-0011', '99999999-9999-4999-8999-000000000001', '33333333-3333-4333-8333-000000000001', CAST(NULL AS uniqueidentifier), 'RECEIVED', '2026-09-21 14:20:00', '2026-09-24', 2276.00),
    ('aaaaaaaa-aaaa-4aaa-8aaa-000000000012', 'TST-ORD-20260923-0012', '99999999-9999-4999-8999-000000000003', '33333333-3333-4333-8333-000000000002', CAST(NULL AS uniqueidentifier), 'CANCELED', '2026-09-23 11:05:00', '2026-09-26', 1661.00)
) AS source (id, code, customer_id, branch_id, salesperson_id, status, order_date, estimated_delivery_date, total)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        code = source.code,
        customer_id = source.customer_id,
        branch_id = source.branch_id,
        salesperson_id = source.salesperson_id,
        status = source.status,
        order_date = source.order_date,
        estimated_delivery_date = source.estimated_delivery_date,
        total = source.total
WHEN NOT MATCHED THEN
    INSERT (id, code, customer_id, branch_id, salesperson_id, status, order_date, estimated_delivery_date, total)
    VALUES (source.id, source.code, source.customer_id, source.branch_id, source.salesperson_id, source.status, source.order_date, source.estimated_delivery_date, source.total);

-- ----------------------------------------------------------------------------
-- Detalle de órdenes
-- ----------------------------------------------------------------------------
MERGE INTO order_items WITH (HOLDLOCK) AS target
USING (VALUES
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000001', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000001', '66666666-6666-4666-8666-000000000001', 20, 38.50),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000002', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000001', '66666666-6666-4666-8666-000000000009', 10, 98.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000003', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000001', '66666666-6666-4666-8666-000000000011', 12, 49.50),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000004', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000002', '66666666-6666-4666-8666-000000000005', 15, 64.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000005', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000002', '66666666-6666-4666-8666-000000000017', 20, 35.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000006', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000002', '66666666-6666-4666-8666-000000000021', 10, 60.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000007', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000003', '66666666-6666-4666-8666-000000000002', 12, 52.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000008', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000003', '66666666-6666-4666-8666-000000000012', 24, 55.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000009', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000003', '66666666-6666-4666-8666-000000000022', 20, 45.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000010', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000004', '66666666-6666-4666-8666-000000000005', 10, 64.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000011', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000004', '66666666-6666-4666-8666-000000000009', 8, 98.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000012', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000004', '66666666-6666-4666-8666-000000000016', 6, 78.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000013', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000005', '66666666-6666-4666-8666-000000000003', 15, 89.90),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000014', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000005', '66666666-6666-4666-8666-000000000008', 10, 72.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000015', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000005', '66666666-6666-4666-8666-000000000019', 8, 95.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000016', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000006', '66666666-6666-4666-8666-000000000001', 30, 38.50),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000017', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000006', '66666666-6666-4666-8666-000000000010', 5, 210.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000018', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000006', '66666666-6666-4666-8666-000000000020', 4, 180.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000019', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000007', '66666666-6666-4666-8666-000000000006', 8, 145.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000020', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000007', '66666666-6666-4666-8666-000000000013', 4, 320.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000021', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000007', '66666666-6666-4666-8666-000000000018', 6, 120.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000022', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000008', '66666666-6666-4666-8666-000000000004', 20, 45.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000023', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000008', '66666666-6666-4666-8666-000000000014', 5, 185.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000024', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000008', '66666666-6666-4666-8666-000000000023', 10, 70.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000025', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000009', '66666666-6666-4666-8666-000000000002', 18, 52.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000026', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000009', '66666666-6666-4666-8666-000000000011', 24, 49.50),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000027', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000009', '66666666-6666-4666-8666-000000000024', 12, 85.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000028', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000010', '66666666-6666-4666-8666-000000000007', 10, 58.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000029', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000010', '66666666-6666-4666-8666-000000000015', 3, 165.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000030', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000011', '66666666-6666-4666-8666-000000000009', 12, 98.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000031', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000011', '66666666-6666-4666-8666-000000000012', 20, 55.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000032', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000012', '66666666-6666-4666-8666-000000000003', 10, 89.90),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000033', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000012', '66666666-6666-4666-8666-000000000008', 6, 72.00),
    ('bbbbbbbb-bbbb-4bbb-8bbb-000000000034', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000012', '66666666-6666-4666-8666-000000000015', 2, 165.00)
) AS source (id, order_id, product_id, quantity, unit_price)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        order_id = source.order_id,
        product_id = source.product_id,
        quantity = source.quantity,
        unit_price = source.unit_price
WHEN NOT MATCHED THEN
    INSERT (id, order_id, product_id, quantity, unit_price)
    VALUES (source.id, source.order_id, source.product_id, source.quantity, source.unit_price);

-- ----------------------------------------------------------------------------
-- Tickets
-- ----------------------------------------------------------------------------
MERGE INTO tickets WITH (HOLDLOCK) AS target
USING (VALUES
    ('cccccccc-cccc-4ccc-8ccc-000000000001', '99999999-9999-4999-8999-000000000001', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000001', 'Retraso en entrega del pedido TST-ORD-20260901-0001', 'EMAIL', 'RESOLVED', CAST(NULL AS uniqueidentifier), 'NEGATIVE', 'DELAY', 'HUMAN', 0, 3, '2026-09-02 09:15:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000002', '99999999-9999-4999-8999-000000000004', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000002', 'Producto faltante en surtido escolar', 'PORTAL', 'IN_PROGRESS', CAST(NULL AS uniqueidentifier), 'NEGATIVE', 'OTHER', 'HUMAN', 1, NULL, '2026-09-06 10:30:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000003', '99999999-9999-4999-8999-000000000007', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000003', 'Solicitud de factura del pedido', 'EMAIL', 'OPEN', CAST(NULL AS uniqueidentifier), 'NEUTRAL', 'INVOICE', 'AGENT', 0, NULL, '2026-09-07 12:00:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000004', '99999999-9999-4999-8999-000000000002', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000004', 'Cambio de dirección de entrega', 'VOICE', 'OPEN', CAST(NULL AS uniqueidentifier), 'NEUTRAL', 'OTHER', 'AGENT', 0, NULL, '2026-09-08 08:45:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000005', '99999999-9999-4999-8999-000000000003', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000005', 'Producto dañado al recibir pedido', 'EMAIL', 'RESOLVED', CAST(NULL AS uniqueidentifier), 'NEGATIVE', 'DAMAGED_PRODUCT', 'HUMAN', 0, 4, '2026-09-12 16:20:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000006', '99999999-9999-4999-8999-000000000006', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000007', 'Retraso en pedido de químicos', 'PORTAL', 'IN_PROGRESS', CAST(NULL AS uniqueidentifier), 'NEGATIVE', 'DELAY', 'HUMAN', 1, NULL, '2026-09-14 11:10:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000007', '99999999-9999-4999-8999-000000000009', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000009', 'Solicitud de cancelación de pedido', 'EMAIL', 'RESOLVED', CAST(NULL AS uniqueidentifier), 'NEUTRAL', 'CANCELLATION', 'HUMAN', 0, 5, '2026-09-18 08:30:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000008', '99999999-9999-4999-8999-000000000008', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000006', 'Cobro incorrecto en pedido', 'PORTAL', 'OPEN', CAST(NULL AS uniqueidentifier), 'NEGATIVE', 'BILLING', 'HUMAN', 1, NULL, '2026-09-12 14:00:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000009', '99999999-9999-4999-8999-000000000010', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000010', 'Aclaración de cancelación', 'EMAIL', 'RESOLVED', CAST(NULL AS uniqueidentifier), 'NEUTRAL', 'CANCELLATION', 'HUMAN', 0, 4, '2026-09-20 10:15:00'),
    ('cccccccc-cccc-4ccc-8ccc-000000000010', '99999999-9999-4999-8999-000000000003', 'aaaaaaaa-aaaa-4aaa-8aaa-000000000012', 'Seguimiento a pedido cancelado', 'VOICE', 'IN_PROGRESS', CAST(NULL AS uniqueidentifier), 'NEGATIVE', 'OTHER', 'HUMAN', 1, NULL, '2026-09-24 15:40:00')
) AS source (id, customer_id, order_id, subject, channel, status, assigned_to, sentiment, topic, handled_by, requires_human_review, rating, created_at)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        customer_id = source.customer_id,
        order_id = source.order_id,
        subject = source.subject,
        channel = source.channel,
        status = source.status,
        assigned_to = source.assigned_to,
        sentiment = source.sentiment,
        topic = source.topic,
        handled_by = source.handled_by,
        requires_human_review = source.requires_human_review,
        rating = source.rating,
        created_at = source.created_at
WHEN NOT MATCHED THEN
    INSERT (id, customer_id, order_id, subject, channel, status, assigned_to, sentiment, topic, handled_by, requires_human_review, rating, created_at)
    VALUES (source.id, source.customer_id, source.order_id, source.subject, source.channel, source.status, source.assigned_to, source.sentiment, source.topic, source.handled_by, source.requires_human_review, source.rating, source.created_at);

-- ----------------------------------------------------------------------------
-- Mensajes de tickets
-- ----------------------------------------------------------------------------
MERGE INTO ticket_messages WITH (HOLDLOCK) AS target
USING (VALUES
    ('dddddddd-dddd-4ddd-8ddd-000000000001', 'cccccccc-cccc-4ccc-8ccc-000000000001', 'CUSTOMER', 'Buen día, el pedido TST-ORD-20260901-0001 no llegó en la fecha estimada.', NULL, NULL, '2026-09-02 09:16:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000002', 'cccccccc-cccc-4ccc-8ccc-000000000001', 'AGENT', 'Estoy revisando el estatus logístico de la orden.', 'CONSULT_ORDER', 'orders:TST-ORD-20260901-0001', '2026-09-02 09:17:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000003', 'cccccccc-cccc-4ccc-8ccc-000000000001', 'EMPLOYEE', 'La entrega se reprogramó para el 3 de septiembre y el cliente fue notificado.', 'ESCALATE', NULL, '2026-09-02 10:00:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000004', 'cccccccc-cccc-4ccc-8ccc-000000000002', 'CUSTOMER', 'Recibimos el pedido pero falta una caja de guantes de nitrilo.', NULL, NULL, '2026-09-06 10:31:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000005', 'cccccccc-cccc-4ccc-8ccc-000000000002', 'AGENT', 'Voy a consultar el detalle surtido de la orden.', 'CONSULT_ORDER', 'orders:TST-ORD-20260903-0002', '2026-09-06 10:32:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000006', 'cccccccc-cccc-4ccc-8ccc-000000000002', 'EMPLOYEE', 'Se generó una reposición y se enviará en la siguiente ruta.', 'ESCALATE', NULL, '2026-09-06 11:00:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000007', 'cccccccc-cccc-4ccc-8ccc-000000000003', 'CUSTOMER', 'Necesito la factura correspondiente al pedido.', NULL, NULL, '2026-09-07 12:01:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000008', 'cccccccc-cccc-4ccc-8ccc-000000000003', 'AGENT', 'Consulté la política de facturación y el área administrativa dará seguimiento.', 'SEARCH_POLICY', 'policy:facturacion', '2026-09-07 12:02:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000009', 'cccccccc-cccc-4ccc-8ccc-000000000004', 'CUSTOMER', 'Quiero cambiar la dirección de entrega del pedido.', NULL, NULL, '2026-09-08 08:46:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000010', 'cccccccc-cccc-4ccc-8ccc-000000000004', 'AGENT', 'Registré la solicitud de cambio de dirección para revisión.', 'CREATE_TICKET', NULL, '2026-09-08 08:47:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000011', 'cccccccc-cccc-4ccc-8ccc-000000000005', 'CUSTOMER', 'Uno de los galones llegó dañado.', NULL, NULL, '2026-09-12 16:21:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000012', 'cccccccc-cccc-4ccc-8ccc-000000000005', 'AGENT', 'Lamento el inconveniente. Estoy validando el producto con la orden.', 'CONSULT_ORDER', 'orders:TST-ORD-20260909-0005', '2026-09-12 16:22:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000013', 'cccccccc-cccc-4ccc-8ccc-000000000005', 'EMPLOYEE', 'Se autorizó la reposición del producto dañado.', 'ESCALATE', NULL, '2026-09-12 17:00:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000014', 'cccccccc-cccc-4ccc-8ccc-000000000006', 'CUSTOMER', 'El pedido de químicos sigue sin llegar.', NULL, NULL, '2026-09-14 11:11:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000015', 'cccccccc-cccc-4ccc-8ccc-000000000006', 'AGENT', 'Consulto el estatus logístico de la orden.', 'CONSULT_ORDER', 'orders:TST-ORD-20260913-0007', '2026-09-14 11:12:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000016', 'cccccccc-cccc-4ccc-8ccc-000000000007', 'CUSTOMER', 'Solicito cancelar el pedido porque cambió el requerimiento.', NULL, NULL, '2026-09-18 08:31:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000017', 'cccccccc-cccc-4ccc-8ccc-000000000007', 'AGENT', 'Revisé la política de cancelación aplicable.', 'SEARCH_POLICY', 'policy:cancelaciones', '2026-09-18 08:32:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000018', 'cccccccc-cccc-4ccc-8ccc-000000000007', 'EMPLOYEE', 'La cancelación fue aprobada y procesada.', 'ESCALATE', NULL, '2026-09-18 09:00:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000019', 'cccccccc-cccc-4ccc-8ccc-000000000008', 'CUSTOMER', 'El cobro no coincide con la cotización enviada.', NULL, NULL, '2026-09-12 14:01:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000020', 'cccccccc-cccc-4ccc-8ccc-000000000008', 'AGENT', 'Voy a revisar el detalle de la orden y la cotización.', 'CONSULT_ORDER', 'orders:TST-ORD-20260911-0006', '2026-09-12 14:02:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000021', 'cccccccc-cccc-4ccc-8ccc-000000000009', 'CUSTOMER', 'Quiero confirmar que la cancelación quedó registrada.', NULL, NULL, '2026-09-20 10:16:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000022', 'cccccccc-cccc-4ccc-8ccc-000000000009', 'EMPLOYEE', 'La cancelación quedó registrada correctamente en el sistema.', 'ESCALATE', NULL, '2026-09-20 10:30:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000023', 'cccccccc-cccc-4ccc-8ccc-000000000010', 'CUSTOMER', 'Necesito seguimiento al pedido cancelado y al reembolso.', NULL, NULL, '2026-09-24 15:41:00'),
    ('dddddddd-dddd-4ddd-8ddd-000000000024', 'cccccccc-cccc-4ccc-8ccc-000000000010', 'AGENT', 'Escalé el caso al área de atención para seguimiento.', 'ESCALATE', NULL, '2026-09-24 15:42:00')
) AS source (id, ticket_id, author, content, action, sources, sent_at)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        ticket_id = source.ticket_id,
        author = source.author,
        content = source.content,
        action = source.action,
        sources = source.sources,
        sent_at = source.sent_at
WHEN NOT MATCHED THEN
    INSERT (id, ticket_id, author, content, action, sources, sent_at)
    VALUES (source.id, source.ticket_id, source.author, source.content, source.action, source.sources, source.sent_at);

COMMIT TRANSACTION;

-- ----------------------------------------------------------------------------
-- Verificación de registros cargados
-- ----------------------------------------------------------------------------
SELECT 'branches' AS entity, COUNT(*) AS total FROM branches WHERE CAST(id AS varchar(36)) LIKE '33333333-%'
UNION ALL
SELECT 'warehouses', COUNT(*) FROM warehouses WHERE CAST(id AS varchar(36)) LIKE '44444444-%'
UNION ALL
SELECT 'categories', COUNT(*) FROM categories WHERE CAST(id AS varchar(36)) LIKE '55555555-%'
UNION ALL
SELECT 'products', COUNT(*) FROM products WHERE CAST(id AS varchar(36)) LIKE '66666666-%'
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers WHERE CAST(id AS varchar(36)) LIKE '77777777-%'
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory WHERE CAST(id AS varchar(36)) LIKE '88888888-%'
UNION ALL
SELECT 'customers', COUNT(*) FROM customers WHERE CAST(id AS varchar(36)) LIKE '99999999-%'
UNION ALL
SELECT 'orders', COUNT(*) FROM orders WHERE CAST(id AS varchar(36)) LIKE 'aaaaaaaa-%'
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items WHERE CAST(id AS varchar(36)) LIKE 'bbbbbbbb-%'
UNION ALL
SELECT 'tickets', COUNT(*) FROM tickets WHERE CAST(id AS varchar(36)) LIKE 'cccccccc-%'
UNION ALL
SELECT 'ticket_messages', COUNT(*) FROM ticket_messages WHERE CAST(id AS varchar(36)) LIKE 'dddddddd-%';

-- ----------------------------------------------------------------------------
-- Verificación de totales de órdenes contra su detalle
-- Debe devolver 0 filas.
-- ----------------------------------------------------------------------------
SELECT
    o.code,
    o.total,
    SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
WHERE CAST(o.id AS varchar(36)) LIKE 'aaaaaaaa-%'
GROUP BY o.id, o.code, o.total
HAVING o.total <> SUM(oi.quantity * oi.unit_price);

-- ----------------------------------------------------------------------------
-- Verificación de tickets con orden de otro cliente
-- Debe devolver 0 filas.
-- ----------------------------------------------------------------------------
SELECT t.id, t.customer_id, o.customer_id AS order_customer_id
FROM tickets t
JOIN orders o ON o.id = t.order_id
WHERE CAST(t.id AS varchar(36)) LIKE 'cccccccc-%'
  AND t.customer_id <> o.customer_id;

$$
