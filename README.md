# RayTracing

Esta es una simulación de un rayo de luz que rebota con un conjunto de esferas. Las esferas pueden tener cualquier distribución arbitraria.

Todos los cálculos están expresados de manera vectorial, lo cual permite que la simulación funcione en cualquier número de dimensiones simplemente cambiando el tamaño de los vectores.

El objetivo original era simular la salida de un rayo de luz desde el centro del sol, pero obviamente la escala no permite simular tantos átomos, al menos con esta *approach*.

La [versión original](https://colab.research.google.com/drive/13z6Xp2l84JcSg4Ms1cRwQSZalnThA6M5?usp=sharing) estaba escrita en python y era más prolija, pero era lenta. Esta versión está escrita en C y es más rápida,
pero no está escrita de una manera muy correcta.

**Ilustración de un recorrido en 2D:**

![Gráfico 2D mostrando el recorrido de un rayo que rebota con un grupo de círculos](/recorrido.png)

**Análisis de los resultados de una simulación en 3D:**

![Gráfico de la distancia recorrida por el rayo en función del radio de la estrella](/plot.png)
