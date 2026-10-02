RetailPro – Consultas de negocio en SQL Server
Proyecto académico de análisis de datos para RetailPro, un negocio minorista ficticio. Este repositorio contiene los scripts SQL que integran la información de ventas, clientes, productos, categorías y regiones, y esta guía explica cómo interpretarlos y ejecutarlos.
Modelo de datos
Tabla	Descripción
`dbo.clientes`	Datos de los clientes (id, nombre, email, fecha de registro).
`dbo.productos`	Catálogo de productos (nombre, precio, stock, categoría).
`dbo.categorias`	Categorías de producto.
`dbo.regiones`	Regiones comerciales (Norte, Centro, Sur). Se crea en el script porque faltaba en el módulo 3.
`dbo.ventas`	Tabla de hechos: cliente, producto, categoría, región, fecha, cantidad y precio unitario.
`ventas` se relaciona con `clientes`, `productos`, `categorias` y `regiones` mediante claves foráneas.
Herramientas utilizadas
Microsoft SQL Server (sintaxis T-SQL).
SQL Server Management Studio (SSMS) para ejecutar los scripts y ver resultados.
Git y GitHub para el control de versiones.
Requisitos previos
SQL Server 2017 o superior. Sirve la edición gratuita Express o Developer.
SSMS instalado.
La base de datos del proyecto con las tablas `clientes`, `productos`, `categorias` y `ventas` ya creadas y con datos (módulos anteriores). Los scripts de este repositorio no las crean.
(Opcional) Git, para clonar el repositorio. Si no lo tenés, podés descargar un ZIP desde GitHub (ver paso 1).
Cómo ejecutar los scripts
Paso 1. Obtener los archivos
Con Git: abrí una terminal y ejecutá:
```bash
  git clone https://github.com/stefaniamartinez/m4_consultas_negocio.git
  ```
Sin Git: en la página del repositorio en GitHub, hacé clic en el botón verde Code y luego en Download ZIP. Descomprimí el archivo en una carpeta de tu computadora.
Paso 2. Conectarte a SQL Server
Abrí SSMS.
En la ventana Connect to Server, completá:
Server name: el nombre de tu instancia (por ejemplo `localhost`, `.\SQLEXPRESS` o `(localdb)\MSSQLLocalDB`).
Authentication: Windows Authentication (o el usuario y contraseña que uses).
Hacé clic en Connect.
Paso 3. Abrir el script
Menú File > Open > File... (o `Ctrl + O`).
Seleccioná el archivo `m5_consultas_joins.sql` de la carpeta del repositorio y hacé clic en Open.
Paso 4. Elegir la base de datos
Antes de ejecutar, indicá en qué base de datos se debe trabajar. Hay dos opciones:
Elegirla en el desplegable de la barra superior de SSMS (junto al botón Execute), o
Agregar esta línea al inicio del script, con el nombre real de tu base:
```sql
  USE [nombre_de_tu_base];
  GO
  ```
Si omitís este paso, SSMS usa `master` y las consultas fallarán con el error Invalid object name.
Paso 5. Ejecutar en el orden correcto
El script no está pensado para ejecutarse completo de una sola vez. El orden importa:
Primero, el bloque de preparación de `regiones`. Seleccioná con el mouse desde `CREATE TABLE dbo.regiones` hasta el último `UPDATE dbo.ventas ...` y presioná F5. Este bloque crea la tabla, la llena, agrega la columna `id_region` a `ventas` y la completa. Ejecutalo una sola vez: si lo repetís, dará error porque los objetos ya existen.
Después, las consultas, de a una. Seleccioná una consulta completa (desde `SELECT` hasta el `;` final) y presioná F5. Si no seleccionás nada, SSMS ejecuta todo el archivo.
> **Importante:** en el archivo, la Consulta 1 aparece antes del bloque de `regiones`. Si la ejecutás primero, falla con *Invalid object name 'dbo.regiones'*. Ejecutá siempre el bloque de preparación antes.
Paso 6. Revisar los resultados
La pestaña Results muestra la tabla de datos devuelta.
La pestaña Messages muestra las filas afectadas y los errores.
Si una consulta no devuelve filas (Consultas 2 y 3), es el resultado esperado: significa que no hay clientes ni productos sin ventas.
Qué hace cada consulta
#	Consulta	Técnica	Qué devuelve
1	Vista base del proyecto	`INNER JOIN`	Cada venta con cliente, producto, categoría, región y total de venta (`cantidad × precio`). Solo aparecen las ventas que tienen datos en todas las tablas relacionadas.
2	Clientes sin ventas	`LEFT JOIN` + `IS NULL`	Clientes que nunca compraron. Sin filas = todos compraron al menos una vez.
3	Productos sin ventas	`LEFT JOIN` + `IS NULL`	Productos que nunca se vendieron. Sin filas = todos tienen ventas.
4	Consolidado por canal	`UNION ALL` + `GROUP BY`	Total vendido por canal. Se asume que la categoría 1 es Online y el resto Presencial.
5	Indicadores de negocio	Agregaciones	Facturación total, cantidad de pedidos, ticket promedio, ranking de productos y clientes, y comparación mensual.
Cómo leer los resultados
`Total_Venta`: cantidad vendida por el precio del producto en esa venta.
`LEFT JOIN ... WHERE ... IS NULL`: técnica para encontrar registros de una tabla que no tienen correspondencia en otra.
`INNER JOIN`: si una venta tiene `id_region` en `NULL`, no aparece en la Consulta 1. Por eso la columna se completa antes de consultar.
Problemas frecuentes
Error	Causa	Solución
`Invalid object name 'dbo.regiones'`	Se ejecutó la Consulta 1 antes de crear `regiones`, o se está usando otra base de datos.	Ejecutar primero el bloque de preparación y verificar la base seleccionada (Paso 4).
`There is already an object named 'regiones'`	El bloque de preparación ya se ejecutó antes.	No volver a ejecutarlo.
`Invalid column name 'id_region'`	Falta el `ALTER TABLE ... ADD id_region`.	Ejecutar el bloque de preparación completo.
`Invalid object name 'dbo.ventas'` (u otra tabla)	Las tablas base no existen en la base seleccionada.	Seleccionar la base correcta o ejecutar los scripts de los módulos anteriores.
Notas para quien use los scripts
Para evitar errores de totales, conviene calcular el total de venta con `precio_unitario` de la venta en lugar del `precio` actual del producto, que puede cambiar con el tiempo.
El conteo de pedidos por cliente debe usar `COUNT(DISTINCT id_venta)` para no contar filas de detalle.
