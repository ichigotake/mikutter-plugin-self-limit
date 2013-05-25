# -*- coding: utf-8 -*-

Plugin.create(:self_limit) do

    limit_now = false

    #規制に関わる情報を保持
    @limit = {
        :limit_now   => false,
        :count       => 0,
        :end_time    => 0,
    }

    def initialize
        UserConfig[:self_limit_limit_time] ||= 0;
        UserConfig[:self_limit_limit_count] ||= 0;
        UserConfig[:self_limit_before_notify] ||= 0;
    end

    filter_gui_postbox_post do |gui_postbox|
        text = Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text

        diff = @limit[:end_time] - Time.now.to_i
        if diff < 0
            @limit[:limit_now] = false
            @limit[:end_time] = 0
        end

        if @limit[:limit_now]
            Plugin.activity :system, "自主規制中だよっ☆\n規制解除まであと" + diff.to_s + "秒"
            clear_post(gui_postbox)
            Plugin.filter_cancel!
        else
            @limit[:count] += 1

            if @limit[:count] >= UserConfig[:self_limit_limit_count].to_i
                @limit[:limit_now]  = true
                @limit[:count] = 0
                @limit[:end_time] = Time.now.to_i + UserConfig[:self_limit_limit_time].to_i

                Reserver.new(UserConfig[:self_limit_limit_time].to_i){
                    Plugin.activity :system, "自主規制中が解除されたよっ"
                }

                Plugin.activity :system, "今から" + UserConfig[:self_limit_limit_time].to_s + "秒の間、自主規制はいりまーす"
            else
                notify_count = UserConfig[:self_limit_limit_count].to_i - @limit[:count] 
                if notify_count == UserConfig[:self_limit_before_notify].to_i
                    Plugin.activity :system, "あと" + notify_count.to_s + "ツイートで自主規制に入るよー"
                end
            end
        end

        [gui_postbox]
    end

    def clear_post(gui_postbox)
        Plugin.call(:before_postbox_post,
                        Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text)
        Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text = ''
    end

    settings "自主規制" do
        settings "自主規制" do
            adjustment("規制ツイート数", :self_limit_limit_count, 0, 10000).
                tooltip "何ツイートで規制に入るかを設定します"
            adjustment("規制の何ツイート前に事前通知をするか", :self_limit_before_notify, 0, 10000).
                tooltip "(規定ツイート数 - この設定値)が現在のツイートカウント数と同じになったら通知の事前告知をします "
            adjustment("自主規制の持続時間(秒)", :self_limit_limit_time, 0, 24*60*60)
        end
        closeup summary = ::Gtk::Label.new(
            "\n\n" +
            "TwitterのAPI規制の様に、自分の発言を規制するプラグインです\n" +
            "\n" +
            "1ツイートをする度にカウントが1ずつ増えていきます\n" +
            "カウントが「規制ツイート数」に達すると発言ができなくなります\n" +
            "ただし、規制されるのは「Ctrl + Enter」等の、\n" +
            "ショートカットキーによるポストのみです\n" +
            "\n" +
            "ツイートボタンによるツイートは規制に関与しません\n" +
            "(どうしても対応したい時などに利用出来る抜け穴です)\n" +
            "\n\n\n" +
            "Twitterに夢中になりすぎないようにするための\n" +
            "「目安」としてご利用ください！ヾ(>ヮ<*)"
        )
    end

end
