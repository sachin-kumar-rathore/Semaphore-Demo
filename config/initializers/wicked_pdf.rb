WickedPdf.config = {
  # :exe_path => "#{Rails.root}/bin/wkhtmltopdf",
  :layout => 'pdf',
  :margin => {
    :top => 30,
    :bottom => 25
  },
  :header => {
    :html => {
      :template => 'layouts/pdf_header.pdf.erb'
    }
  },
  :footer => {
    :html => {
      :template => 'layouts/pdf_footer.pdf.erb'
    }
  }
}

