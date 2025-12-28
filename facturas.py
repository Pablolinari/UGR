import streamlit as st
import functions as fn
import pandas as pd
cursor = st.session_state.cursor
st.set_page_config(page_title="Gestion de facturacion")
st.sidebar.header("Gestion de facturacion")
crear,modificar,consultar,seguro,pago = st.tabs([
    "Crear Factura",
    "Modificar Factura",
    "Consultar Historial ",
    "Consultar Seguro",
    "Registrar Pago",
])
with crear:
    if st.button("Crear tablas"):
        fn.creartablasfacturas(cursor)
    if st.button("Borrar tablas"):
        fn.borrartablas(cursor)
    st.header("Crear Factura")

    with st.form(key="Crear factura"):
        errores = False
        nss=st.text_input("Numero de seguridad social",max_chars=12)
        precio = st.number_input("Precio total", value=0.0, step=0.01, format="%.2f")
        porcentaje = st.number_input("Porcentaje", value=0.0, step=0.01, format="%.2f")
        recursos=st.text_input("Recursos utilizados")
        
        if st.form_submit_button(key="Crear"):
            if len(nss)!=12 or not nss.isdigit():
                st.error("El nss debe tener 12 caracteres y todos ellos enteros")
                errores =True
            if precio <= 0:
                st.error("El precio debe ser un número mayor que cero ")
                errores =True
            if porcentaje <0 or porcentaje > 1:
                    errores =True
                    st.error("El porcentaje debe ser un numero entre 0 y 1")
            if len(recursos)>=300:
                    errores =True
                    st.error("La descripcion debe tener 200 caracteres como maximo")
            if not errores:
                creacion = fn.crearfactura(cursor,nss,precio,porcentaje,recursos)
                if creacion:
                    st.success("Factura creada con exito")
                else:
                    st.error("No existe un paciente con esos datos")
with modificar:
    st.header("Modificar Factura")

    with st.form(key="Modificar factura"):
        errores = False
        idfactura=st.text_input("ID factura")
        telefono = st.text_input("Telefono",value=None)
        precio = st.number_input("Precio total", value=None, step=0.01, format="%.2f")
        porcentaje = st.number_input("Porcentaje", value=None, step=0.01, format="%.2f")
        recursos=st.text_input("Recursos utilizados",value=None)
        datos ={}
        
        if st.form_submit_button(key="Modificar"):
            if len(idfactura)<=0 or not idfactura.isdigit():
                errores =True
                st.error("El id de la  factura debe ser un entero positivo")
            if telefono is not None:
                if len(telefono)<=0 or not telefono.isdigit():
                    errores =True
                    st.error("El telefono debe ser un numero de maximo 15 caracteres")
                else:
                    datos["telefono"]=telefono
            if precio is not None:
                if precio < 0:
                    errores =True
                    st.error("El precio debe ser un número mayor que cero ")
                else:
                    datos["precio"]=precio
            if porcentaje is not None:
                if porcentaje <0 or porcentaje > 1:
                    errores =True
                    st.error("El porcentaje debe ser un numero entre 0 y 1")
                else:
                    datos["porcentaje"]=porcentaje
            if recursos is not None:
                if len(recursos)>=300:
                    errores =True
                    st.error("La descripcion debe tener 200 caracteres como maximo")
                else:
                    datos["recursos"]=recursos
            if not errores:

                resultado =fn.modificarfactura(cursor,datos,idfactura)
                if resultado:
                    st.success("Factura modificada con exito")
                else:
                    st.error("ID Factura no existe")


with seguro:
    st.header("Consultar seguro")
    col1,col2=st.columns(2)
    with col1:
        st.header("Buscar por NSS")
        nss = st.text_input("NSS asegurado")
        if not (len(nss) == 12 and nss.isdigit()):
            st.error("El NSS debe ser una cadena de 12 caracteres")
        else:
            cursor.execute(f"""SELECT * FROM SEGURO WHERE nss = {nss}""")
            rows = cursor.fetchall()
            columnas = [column[0] for column in cursor.description]
            df = pd.DataFrame.from_records(rows, columns=columnas)
            st.dataframe(data=df)
    with col2:
        st.header("Buscar por ID Seguro")
        id = st.text_input("ID Seguro")
        if id.isdigit(): 
            cursor.execute(f"""SELECT * FROM SEGURO WHERE id = {id}""")
            rows = cursor.fetchall()
            columnas = [column[0] for column in cursor.description]
            df = pd.DataFrame.from_records(rows, columns=columnas)
            st.dataframe(data=df)
        else:
            st.error("El id debe ser un entero")

with pago:
    st.header("Registrar pago")
    with st.form(key="Registrar pago"):
        errores = False
        dni=st.text_input("DNI Pagador")
        nombre =st.text_input("Nombre Pagador")
        apellidos=st.text_input("Apellidos pagador")
        tarjeta=st.text_input("Numero de tarjeta")
        idfactura = st.text_input("Id factura")
        
        if st.form_submit_button(key="Pago"):
            ### cambiar longitud
            if len(dni) != 9 or not dni[0:-1].isdigit() or not dni[-1].isalpha():
                st.error("El DNI es incorrecto")
                errores =True
            if not nombre.isalpha():
                st.error("El nombre debe ser una cadena de caracteres")
                errores =True
            if not apellidos.isalpha():
                st.error("El apellido debe ser una cadena de caracteres")
                errores =True
            if not tarjeta.isdigit():
                st.error("la tarjeta debe ser un entero")
                errores =True
            if not idfactura.isdigit():
                st.error("El id de factura debe ser un entero")
                errores =True            
            if not errores:
                getsql = "SELECT idfactura ,nss, dnipagador FROM factura WHERE idfactura = ?"
                cursor.execute(getsql, (idfactura,))
                fila1 = cursor.fetchone()

                getsql = "SELECT * FROM pagador WHERE dni = ?"
                cursor.execute(getsql, (dni,))
                fila2 = cursor.fetchone()
                if fila1[2]:
                    st.error(f"La factura ya ha sido pagada por {fila1[2]}")
                else:
                    if fila1 and not fila2:
                        fn.registrarpagador(cursor,dni,nombre,apellidos,tarjeta,idfactura)
                        st.success("Pago registrado con exito")
                    if fila1 and fila2:
                        fn.registrapago(cursor,dni,idfactura)
                        st.success("Pago registrado con exito")




with consultar:
    st.header("Consultar Historial de facturas")
    with st.form(key="historial"):
        nss = st.text_input("NSS",value=None,max_chars=12)
        if nss is not None:
            if len(nss)!=12 or not nss.isdigit():
                st.error("El nss debe tener 12 caracteres y todos ellos enteros")
                nss=None
        if st.form_submit_button("Buscar"):
            st.write("Buscando por nss")

    pagadas ,nopagadas = st.columns(2)

    with pagadas:
        st.header("Facturas pagadas")
        if nss:
            cursor.execute("""SELECT * FROM FACTURA WHERE dnipagador IS NOT NULL AND nss = ?;""",(nss,))
        else:
            cursor.execute("""SELECT * FROM FACTURA WHERE dnipagador IS NOT NULL;""")

        rows = cursor.fetchall()
        columnas = [column[0] for column in cursor.description]
        df = pd.DataFrame.from_records(rows, columns=columnas)
        st.dataframe(data=df)
    with nopagadas:
        st.header("Facturas no pagadas")
        if nss:
            cursor.execute("""SELECT * FROM FACTURA WHERE dnipagador IS  NULL AND nss = ?;""",(nss,))
        else:
            cursor.execute("""SELECT * FROM FACTURA WHERE dnipagador IS NULL;""")

        rows = cursor.fetchall()
        columnas = [column[0] for column in cursor.description]
        df = pd.DataFrame.from_records(rows, columns=columnas)
        st.dataframe(data=df)


