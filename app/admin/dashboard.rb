ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do
      column do
        panel "Настройки сайта" do
          pref = Preference.first
          unless pref.blank?
            div image_tag pref.file.variant(resize: "100x100").processed unless pref.file
            div do
              ul do
                li pref.about
              end
            end
          end
        end
      end

      column do
        panel "Собаки" do
          para "Последние добавленные"
        end
      end
    end
  end
end
