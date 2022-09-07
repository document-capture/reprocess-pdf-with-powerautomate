# About this repository
This repo is a proof of concept how to integrate reprocessing of pdf files where OCR cannot read correct data.
In most cases the problem can be solved by re-printing the broken pdf on another software pdf printer.
This app is intended as short track for users, as they can initiate the reprocessing directly from the Document Capture Journal.

# Solution description
The solution is based on two components:

## 1. Microsoft Power Automate Worklow
The flow acts as a HTTP Post Webservice that can receive the broken pdf.
The flow converts the received file into a TIFF format to get rid of any pdf related problems.
Finally it converts the TIFF back into a PDF and sends it by mail to the Document Capture OCR email address that is setup for the Document Category.

![](https://github.com/document-capture/reprocess-pdf-with-powerautomate/blob/main/media/Power-Automate_Flow.png)

You can find the flow in the power-auomate-flow folder of this repository.

## 2. Business Central app
The app adds an action to the Document Journal that can be triggered by the user to start the reprocessing.
In the background it handles the whole process of exporting the pdf, building the Webservice query and sends the document.

First of all the user should setup the Power Automate Webservice URL in the new field on the Document Capture Setup card

![](https://github.com/document-capture/reprocess-pdf-with-powerautomate/blob/main/media/Document-Capture-Setup.png)

Send the current selected document into the reprocessing
![](https://github.com/document-capture/reprocess-pdf-with-powerautomate/blob/main/media/Document-Journal_StartReprocessing.png)

## Remark ##
The Power Automate Flow is using [encodian](https://encodian.com/products/flowr/]) connectors for the conversion. For frequent usage this requires a paid subscription at encodian that needs to be paid by the end users.

You can use this code as it is, without any warranty or support by me or [Continia Software A/S](https://www.continia.com "Continia Software"). 

You can use the app on your own risk. 

**If you find issues in the code, please report these in the issues list here on Github.**
