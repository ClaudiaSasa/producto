/* ==========================================
   HERBOLARIO GOURMET
   JavaScript
   ========================================== */


/* ================= CARRITO ================= */

let carrito = [];


/* Agregar producto */

function agregarCarrito(nombre, precio) {

    carrito.push({
        nombre: nombre,
        precio: precio
    });

    actualizarContador();

    alert(
        "🌿 " + nombre +
        " fue agregado al carrito."
    );
}


/* Actualizar contador */

function actualizarContador() {

    const contador =
        document.getElementById("contador");

    contador.textContent =
        carrito.length;
}


/* Mostrar carrito */

function mostrarCarrito() {

    const modal =
        document.getElementById("modal-carrito");

    modal.style.display = "flex";

    actualizarCarrito();
}


/* Cerrar carrito */

function cerrarCarrito() {

    const modal =
        document.getElementById("modal-carrito");

    modal.style.display = "none";
}


/* Actualizar contenido */

function actualizarCarrito() {

    const lista =
        document.getElementById("lista-carrito");

    const totalElemento =
        document.getElementById("total");


    if (carrito.length === 0) {

        lista.innerHTML =
            "<p>Tu carrito está vacío.</p>";

        totalElemento.textContent =
            "$0";

        return;
    }


    lista.innerHTML = "";

    let total = 0;


    carrito.forEach(function(producto, indice) {

        total += producto.precio;


        const item =
            document.createElement("div");

        item.className =
            "item-carrito";


        item.innerHTML = `

            <span>
                ${producto.nombre}
            </span>

            <strong>
                $${producto.precio.toLocaleString()}
            </strong>

            <button
                onclick="eliminarProducto(${indice})">
                ❌
            </button>

        `;


        lista.appendChild(item);

    });


    totalElemento.textContent =
        "$" + total.toLocaleString();
}


/* Eliminar producto */

function eliminarProducto(indice) {

    carrito.splice(indice, 1);

    actualizarContador();

    actualizarCarrito();
}


/* ================= FINALIZAR COMPRA ================= */

function finalizarCompra() {

    if (carrito.length === 0) {

        alert(
            "El carrito está vacío."
        );

        return;
    }


    alert(
        "🌿 Gracias por tu compra en " +
        "Herbolario Gourmet."
    );

}


/* ================= BUSCADOR ================= */

function buscarProducto() {

    const texto =
        document
        .getElementById("buscador")
        .value
        .toLowerCase();


    const productos =
        document.querySelectorAll(".producto");


    productos.forEach(function(producto) {

        const nombre =
            producto.dataset.nombre;


        if (nombre.includes(texto)) {

            producto.style.display =
                "block";

        } else {

            producto.style.display =
                "none";

        }

    });

}


/* ================= FILTRAR CATEGORÍA ================= */

function filtrarCategoria(categoria) {

    const productos =
        document.querySelectorAll(".producto");


    productos.forEach(function(producto) {

        if (
            producto.dataset.categoria === categoria
        ) {

            producto.style.display =
                "block";

        } else {

            producto.style.display =
                "none";

        }

    });


    document
        .getElementById("productos")
        .scrollIntoView({
            behavior: "smooth"
        });

}


/* ================= FORMULARIO ================= */

function enviarFormulario(event) {

    event.preventDefault();


    const nombre =
        document.getElementById("nombre").value;


    const respuesta =
        document.getElementById("respuesta");


    respuesta.textContent =
        "Gracias " +
        nombre +
        ". Tu mensaje fue recibido correctamente. 🌿";


    document
        .querySelector("form")
        .reset();

}


/* ================= CARGA ================= */

window.addEventListener(
    "load",
    function() {

        console.log(
            "Herbolario Gourmet cargado correctamente."
        );

    }
);