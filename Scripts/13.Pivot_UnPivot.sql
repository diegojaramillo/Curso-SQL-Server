--Diego Jaramillo
--EJEMPLO PIVOT TABLE
--SELECCIONAR DATOS DE LA TABLA ORIGINAL
SELECT DaysToManufacture, AVG(StandardCost) AS AverageCost
FROM Production.Product
GROUP BY DaysToManufacture;

--HACEMOS EL PIVOT
SELECT 'AverageCost' as Cost_sorted_by_production_days
		, [0], [1], [2], [3], [4]
FROM (SELECT DaysToManufacture, StandardCost
		FROM Production.Product) AS SourceTable
PIVOT 
(AVG(StandardCost)
FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
) AS PivotTable;

--CREAR TABLA BASADA EN EL ANTERIOR PIVOT
SELECT 'AverageCost' as Cost_sorted_by_production_days
		, [0], [1], [2], [3], [4] INTO #PivotTable
FROM (SELECT DaysToManufacture, StandardCost
		FROM Production.Product) AS SourceTable
PIVOT 
(AVG(StandardCost)
FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
) AS PivotTable;

--HACEMOS UNPIVOT
select * from #PivotTable

SELECT DaysToManufacture, AverageCost
FROM (SELECT Cost_sorted_by_production_days, [0], [1], [2], [3], [4]
		FROM #PivotTable) SourceTable
UNPIVOT
(AverageCost 
FOR DaysToManufacture IN ([0], [1], [2], [3], [4])) 
AS UnPivotTable;

