
--Consulta 1.
--Resumen ejecutivo mensual Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. 
--Calculá el total como cantidad * precio_unitario. Usá alias descriptivos en español y agrupá por mes con EXTRACT(MONTH FROM fecha_venta).

SELECT 
SUM(cantidad * precio_unitario) AS Total_facturado,
COUNT(id_venta) AS Cantidad_Pedidos,
SUM(cantidad * precio_unitario) / COUNT(id_venta) AS Ticket_promedio,
MONTH(fecha_venta) AS mes
FROM dbo.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


--Consulta 2.
--Ranking de productos Top 5 de id_producto por total facturado, mostrando las unidades vendidas (SUM(cantidad)) y el total generado. 
--Usá GROUP BY id_producto, ORDER BY y limitá el resultado a 5.

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM dbo.ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--Consulta 3. 
--Clientes recurrentes id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. 
--Usá GROUP BY id_cliente y HAVING COUNT(*) > 1.

SELECT 
    id_cliente,
    SUM(cantidad) AS Cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
    FROM dbo.ventas
    GROUP BY id_cliente
    HAVING COUNT (*) >1
    ORDER BY total_gastado DESC;


--Consulta 4.
--Meses por encima/por debajo del promedio Total facturado por mes, con una columna adicional que etiquete con CASE WHEN si ese mes quedó 'Por encima' o 'Por debajo' del promedio mensual general.


SELECT 
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_facturado,
    CASE
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT AVG(TotalMes) 
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS TotalMes
                FROM dbo.ventas
                GROUP BY MONTH(fecha_venta)
            ) AS Subconsulta
        ) THEN 'Por_Encima'
        ELSE 'Por_Debajo'
    END AS Comparacion
FROM dbo.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY Mes;

--Bloque de cierre Al final del archivo agregá un bloque de comentarios -- con 3 hallazgos concretos que encontraste al revisar los resultados. 
--Por ejemplo: "El producto 1 concentra el 40% de la facturación del trimestre."

-- 1. El producto 1 concentra la mayor facturación a pesar de no ser el más vendido en unidades;
--    el producto 2, en cambio, lidera en unidades vendidas pero factura menos, lo que indica
--    que su precio unitario es considerablemente más bajo.
-- 2. El cliente 1 es el que más gastó del período analizado.
-- 3. Marzo fue uno de los meses por debajo del promedio de facturación mensual.