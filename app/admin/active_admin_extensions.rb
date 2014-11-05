ActiveAdmin::Views::IndexAsTable.class_eval do
  def editable_text_column resource, attr
    val = resource.send(attr)
    val = "&nbsp;" if val.blank?

    html = %{
                  <div  id='editable_text_column_#{resource.id}'
                        class='editable_text_column'>
                        #{val}
                   </div>

                   <input data-path='#{resource.class.name.tableize}'
                      data-attr='#{attr}'
                      data-resource-id='#{resource.id}'
                      class='editable_text_column admin-editable'
                      id='editable_text_column_#{resource.id}'

                      style='display:none;' />
              }
    html.html_safe
  end
end

Formtastic::Inputs::FileInput.class_eval do
  def to_html
    input_wrapping do
      label_html <<
      builder.file_field(method, input_html_options) <<
      image_preview_content
    end
  end
  private
  def image_preview_content
    image_preview? ? image_preview_html : ""
  end
  def image_preview?
    options[:image_preview] && @object.send(method).present?
  end
  def image_preview_html
    template.image_tag(@object.send(method).url, :class => "image-preview")
  end
end