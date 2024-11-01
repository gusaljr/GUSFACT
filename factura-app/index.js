const express = require('express');
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(express.static('public'));
app.use(express.json()); // Para poder leer JSON en las peticiones

app.post('/generate-invoice', (req, res) => {
    const invoiceData = req.body; // Obtener datos de la factura

    // Crear un nuevo PDF
    const doc = new PDFDocument();
    const filename = `invoice_${Date.now()}.pdf`;
    const filePath = path.join(__dirname, filename);
    
    // Pipe del PDF a un archivo
    doc.pipe(fs.createWriteStream(filePath));
    
    // Agregar contenido al PDF (esto debe adaptarse a tus datos)
    doc.fontSize(25).text('Factura', { align: 'center' });
    doc.text(`Cliente: ${invoiceData.clientName}`);
    doc.text(`Total: ${invoiceData.total}`);
    
    // Finalizar el PDF
    doc.end();

    // Esperar a que el PDF esté generado
    doc.on('finish', () => {
        res.download(filePath, filename, (err) => {
            if (err) {
                console.log(err);
            }
            // Eliminar el archivo después de enviarlo
            fs.unlinkSync(filePath);
        });
    });
});

// Endpoint para obtener la vista previa del PDF
app.post('/preview-invoice', (req, res) => {
    const invoiceData = req.body; // Obtener datos de la factura

    // Crear un nuevo PDF en memoria
    const doc = new PDFDocument();
    let buffers = [];
    
    // Agregar contenido al PDF
    doc.on('data', buffers.push.bind(buffers));
    doc.on('end', () => {
        const pdfData = Buffer.concat(buffers);
        res.contentType("application/pdf");
        res.send(pdfData); // Enviar PDF como respuesta
    });

    doc.fontSize(25).text('Factura', { align: 'center' });
    doc.text(`Cliente: ${invoiceData.clientName}`);
    doc.text(`Total: ${invoiceData.total}`);
    
    // Finalizar el PDF
    doc.end();
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
