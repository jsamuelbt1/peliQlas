Práctica 4 Navegación, estado compartido y propuesta de arquitectura
MVVM y arquitectura

1. ¿Por qué es conveniente separar responsabilidades dentro de una aplicación?

Separar responsabilidades significa que cada parte de una aplicación tenga una sola tarea clara. Esto es conveniente porque:

Facilita la comprensión del código. Si hay un error, es más fácil saber en qué archivo buscarlo.
Reduce el riesgo al hacer cambios. Se puede modificar la interfaz sin afectar la lógica ni los datos.
Permite reutilizar código. La misma lógica puede usarse en varias pantallas.
Facilita las pruebas. La lógica separada de la interfaz puede probarse sin ejecutar la app.
Permite el trabajo en equipo. Distintas personas pueden trabajar en distintas partes sin estorbarse.
Ayuda a que la aplicación crezca. Agregar funciones, pantallas o una API no vuelve el proyecto inmanejable.

## 2. Diferencia entre código de interfaz, datos y lógica

| Tipo de código | Qué hace | Ejemplos |
|---|---|---|
| **Interfaz** | Define cómo se ve la aplicación y captura las acciones del usuario | Botones, textos, listas, colores, márgenes |
| **Datos** | Describe y almacena la información que maneja la aplicación | Estructuras como una película, un usuario o un producto |
| **Lógica** | Decide qué hacer con los datos y cómo reaccionar a las acciones del usuario | Filtrar resultados de una búsqueda, marcar favoritos, validar información |

3. Problemas cuando una View concentra demasiadas responsabilidades

Es común que al inicio todo quede dentro de la View, y de ahí viene el llamado “Massive View”. Los problemas son:

Archivos largos y difíciles de leer, porque mezclan diseño con reglas de negocio.
Lógica duplicada. Si dos pantallas necesitan la misma regla, se copia y pega.
Difícil de probar. Para probar el filtrado habría que crear la vista completa.
Cambios riesgosos. Al mover un botón puedes dañar sin querer la lógica de al lado.
Previews y mantenimiento más complicados, porque la vista depende de muchas cosas a la vez.
Dificultad para integrar una API o una base de datos después, ya que la vista tendría que saber de dónde vienen los datos.

4. ¿Qué es Model?

El Model representa los datos y las reglas básicas del dominio de la app. No sabe nada de pantallas ni de botones: solo describe la información.

En PeliQlas, Movie es un Model. Más adelante, si se agrega un perfil de usuario como estructura (Profile), también sería Model.|

5. ¿Qué es View?

La View es la parte visible: muestra la información al usuario y recibe sus acciones (toques, texto, etc.). Debe ser lo más sencilla posible: no decide nada, solo dibuja lo que le dan y avisa cuando el usuario hace algo.

En SwiftUI, las vistas son los struct que conforman a View: WelcomeView, MovieListView, MovieDetailView, PosterView.

6. ¿Qué es ViewModel?

El ViewModel es el intermediario entre el Model y la View. Tiene tres funciones:

Prepara los datos para mostrarlos. Por ejemplo, convierte el rating 8.4 en el texto "8.4 / 10".
Contiene la lógica de la pantalla. Filtrar, ordenar, marcar favoritas.
Notifica a la View cuando algo cambia. En SwiftUI se hace con ObservableObject y @Published (o con @Observable en iOS 17+).

## 7. ¿Cómo fluye la información entre estos componentes?

La información en MVVM fluye en un ciclo de cuatro pasos:

1. **El usuario interactúa con la View.** Por ejemplo, toca un botón, escribe en un buscador o selecciona un elemento de la lista.
2. **La View notifica la acción al ViewModel.** La View no toma decisiones: solo avisa que algo ocurrió llamando a una función del ViewModel.
3. **El ViewModel consulta o actualiza el Model.** Aplica la lógica necesaria (filtrar, ordenar, marcar un favorito) y obtiene o modifica los datos.
4. **El ViewModel actualiza su estado y la View se redibuja automáticamente.** En SwiftUI esto ocurre gracias a `ObservableObject` y `@Published`, que avisan a la View cuando hay cambios.

En resumen: **Usuario → View → ViewModel → Model**, y el resultado regresa en sentido contrario: **Model → ViewModel → View → Usuario**.

La View conoce al ViewModel y el ViewModel conoce al Model, pero **el ViewModel no conoce a la View** ni el Model conoce al ViewModel. Esta dependencia en una sola dirección mantiene el código ordenado y permite cambiar una parte sin afectar a las demás.

### Ejemplo en PeliQlas

1. El usuario escribe "Dune" en el buscador (**View**).
2. La View le pasa ese texto al **ViewModel**.
3. El ViewModel filtra la lista de películas del **Model** y se queda con las que coinciden.
4. La lista filtrada se publica y la **View** se actualiza para mostrar solo esas películas.


9. Propuesta inicial de organización con MVVM
Model
Movie: título, año, géneros, calificación, director, actores e imagen.
Profile: nombre del perfil de usuario.
View
WelcomeView: selección de perfil y botón para entrar.
MovieListView: buscador y lista de películas.
MovieDetailView: información completa de la película, botón de favorito y botón para regresar.
PosterView: componente reutilizable para mostrar el póster.
Responsabilidades que podrían vivir fuera de las View
Filtrar películas según el texto de búsqueda.
Consultar y modificar favoritos.
Guardar el perfil seleccionado.
Dar formato a los textos que se muestran.
Obtener la lista de películas (hoy local, en el futuro desde una API).





