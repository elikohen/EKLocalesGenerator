module Fastlane
  module Actions
    module SharedValues
    end

    class EkLocalesAction < Action
      def self.run(params)

        require 'fileutils'

        clientId = params[:google_client_id]
        if clientId.nil?
          # Using EKGDevelopment client id
          clientId = "1063903384675-02js9jrt297u136fa6pq591i2ul9s86p.apps.googleusercontent.com"
        end
        clientSecret = params[:google_client_secret]
        if clientSecret.nil? 
          # Using EKGDevelopment client secret
          clientSecret = "VL5mQuwxMainnS3uiNEMCkNF"
        end
        localizablesDir = params[:localizables_dir]
        spreadsheetName = params[:spreadsheet_name]
        pathToRepo = params[:repository_path]
        markUnused = params[:mark_unused]

        setup = Setup.new
        platformParameter = ""
        extraParams = ""
        if setup.is_android?
          platformParameter = "-a"
        elsif setup.is_ios?
          platformParameter = "-i"
          extraParams = "-n LocalizedString -k"
        else
          UI.user_error!('Please run EkLocales Action from an ios or android project')
        end

        projectDir = (Actions.sh "pwd").strip+"/"
        if !pathToRepo.nil? 
          projectDir = projectDir+pathToRepo
        end

        scriptDir = "#{Dir.home}/.ekscripts/locales-generator/"
        if File.exist?(scriptDir)
          Actions.sh "cd #{scriptDir} && git checkout . && git pull > /dev/null"
        else
          Actions.sh "mkdir -p #{scriptDir} && git clone https://github.com/elikohen/EKLocalesGenerator.git #{scriptDir} > /dev/null && cd #{scriptDir} && bundle install"
        end

        command = "./localizable-generator --client-id=#{clientId} --client-secret=#{clientSecret}"
        command << " -s #{spreadsheetName} #{platformParameter} #{projectDir}#{localizablesDir} #{extraParams}"
        if markUnused 
          command << " -c -m"
        end
        Actions.sh "cd #{scriptDir} && #{command}"

      end


      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Action that uses EKLocalesGenerator project: https://github.com/elikohen/EKLocalesGenerator, more info there"
      end

      def self.available_options
        [FastlaneCore::ConfigItem.new(key: :spreadsheet_name,
                                       env_name: "EK_LOCALES_GOOGLE_SPREADSHEET_NAME",
                                       description: "Name of spreadsheet. I.E. if spreadsheet is '[Localizables] myProject', you must set 'myProject'",
                                       optional: false),
        FastlaneCore::ConfigItem.new(key: :localizables_dir,
                                       env_name: "EK_LOCALES_GOOGLE_LOCALIZABLES_DIR",
                                       description: "Directory of .lproj files on iOS and res directory on android",
                                       optional: false),
        FastlaneCore::ConfigItem.new(key: :google_client_id,
                                       env_name: "EK_LOCALES_GOOGLE_CLIENT_ID",
                                       description: "Custom google apps client id",
                                       optional: true),
        FastlaneCore::ConfigItem.new(key: :google_client_secret,
                                       env_name: "EK_LOCALES_GOOGLE_CLIENT_SECRET",
                                       description: "Custom google apps client secret",
                                       optional: true),
        FastlaneCore::ConfigItem.new(key: :repository_path,
                                       env_name: "EK_LOCALES_REPO_PATH",
                                       description: "Path to the repository",
                                       optional: true), 
        FastlaneCore::ConfigItem.new(key: :mark_unused,
                                       env_name: "EK_LOCALES_MARK_UNUSED",
                                       description: "Mark all the unused strings in Localizables",
                                       optional: true,
                                       is_string: false)]
      end

      def self.example_code
        [
          "ek_locales(
            spreadsheet_name: 'myProject',
            localizables_dir: 'myProject/i18n/'
          )",
          "ek_locales(
            google_client_id: 'someid-somehash.apps.googleusercontent.com',
            google_client_secret: 'someHexa64Secret'',
            spreadsheet_name: 'myProject',
            localizables_dir: 'myProject/i18n/',
            repository_path: 'some/temporal/subdir/',
            mark_unused: true
          )",
        ]
      end

      def self.output
      end

      def self.author
        "Eli kohen"
      end

      def self.is_supported?(platform)
        platform == :ios || platform == :android
      end
    end
  end
end
