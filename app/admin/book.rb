ActiveAdmin.register Book do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  
  index do
    selectable_column
    id_column
    column :title, :sortable => :title do |resource|
      editable_text_column resource, :title
    end
    column :price, :sortable => :price do |resource|
      editable_text_column resource, :price
    end
    column :created_at
    column :updated_at
    actions
  end
  permit_params :title, :author, :price, :genre, :description, :author_id, :published_year, :publisher, :language, :rating, :cover  
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :author
      f.input :price
      f.input :genre
      f.input :description
      f.input :publisher
      f.input :published_year
      f.input :language
      f.input :rating
    end
    
    f.input :cover, :image_preview => true
    
    # f.inputs "Attachment", :multipart => true do 
      # f.input :cover, :as => :file, :hint => f.object.cover.present? \
        # ? f.template.image_tag(f.object.cover.url(:thumb))
        # : f.template.content_tag(:span, "no cover image yet")
        # # f.input :cover_cache, :as => :hidden
    # end
    
    f.actions
  end
  
  show do |book|
      attributes_table do
        row :cover do
          image_tag(book.cover.url(:thumb))
        end
        row :id
        row :title
        row :author
        row :price
        row :genre
        row :description
        row :publisher
        row :published_year
        row :language
        row :rating
        row :created_at
        row :updated_at
      end
    active_admin_comments
  end

end
