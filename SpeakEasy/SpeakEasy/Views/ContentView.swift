//
//  ContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import SwiftUI
import PDFKit
import Alamofire

//
//  PDF section begins
//

struct PDFKitView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        //
    }
}

class PDFDownloader {
    static func downloadPDF(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            let directory = FileManager.default.temporaryDirectory
            let filePath = directory.appendingPathComponent(UUID().uuidString + ".pdf")
            return (filePath, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, to: destination).response { response in
            if response.error == nil, let pdfURL = response.fileURL {
                completion(pdfURL)
            } else {
                print("Error downloading PDF: \(response.error?.localizedDescription ?? "unknown error")")
                completion(nil)
            }
        }
    }
}


struct PdFContentView: View {
    @State private var pdfURL: URL?
    
    var body: some View {
        VStack {
            if let pdfURL = pdfURL {
                PDFKitView(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Button("Download PDF") {
                    PDFDownloader.downloadPDF(from: "https://static.kod.us/files/swebok-v3.pdf") { url in
                        self.pdfURL = url
                    }
                }
            }
        }
    }
}

func extractText(from pdfDocument: PDFDocument) -> String? {
    var extractedText = ""
    for pageIndex in 0..<pdfDocument.pageCount {
        guard let page = pdfDocument.page(at: pageIndex) else { continue }
        guard let pageText = page.string else { continue }
        extractedText += pageText
    }
    return extractedText.isEmpty ? nil : extractedText
}


//
//  PDF section ends
//



struct SelectLocalFileView: View {

    var body: some View {
        NavigationLink(destination: LocalFileView()) {
            Btn(title: "Select Local File")
        
        }
    }

}
struct SelectUrlView: View {
    
    var body: some View {
        NavigationLink(destination: UrlFileView()) {
            Btn(title:"Select URL")
        }
    }
}

struct LastUsedView: View {
    var body: some View {
        NavigationLink(destination: ListHistoryView()) {
            Btn(title:"See last viewed files")
        }
    }
}

// Url files
struct UrlFileView: View {
    var body: some View {
            Text("Here you would input a url..")
    }
    // TODO: This would call a pdf link
    // once the link is found it should save it locally
    // the files should turn up in the local files
    // this way they have it offline as well.
}

// Local files
struct LocalFileView: View {
    var body: some View {
            Text("Here you would choose a file..")
    }
    // TODO: We need to allow the user to select the
    // file they want to load int
}

// ListView to display last used items
struct ListHistoryView: View {
    var body: some View {
        List {
            Text("Document PDF 1")
            Text("Document PDF 2")
            Text("Document PDF 3")
        }
    }
    // TODO: Here we would have a history of
    // the pdf files the user has played.
    // history should not repeat the same file
    
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                SelectLocalFileView()
                SelectUrlView()
                LastUsedView()
            }
            .padding()
        }
    }
    // TODO: Implement logic for url view
    // TODO: Implement logic for local file view
    // TODO: Implement logic for history (last used) view
    
    // TODO: Missing the logic of loading in the file to
    // be read.
    
    // TODO: Missing the display logic for the text itself
    
    // TODO: create backend for regex

}

struct Btn: View {
    var title: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 68 / 255, green: 41 / 255, blue: 182 / 255))
                .frame(height: 60)
                .cornerRadius(10)
                .padding(5)
            Text(title).foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}