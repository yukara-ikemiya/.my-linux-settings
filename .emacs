(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(line-number-mode t)
 '(standard-indent 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default c-basic-offset 1  ;;基本インデント量
              tab-width 4     ;;タブ幅4
			  indent-tabs-mode t
              )  ;;インデントをタブでするかスペースでするか



;;Windowサイズと色を設定

;; set window status
(if window-system (progn
					(setq initial-frame-alist '((width . 130)(height . 50)(top . 0)(left . 0)))
					(set-background-color "Black")
					(set-foreground-color "White")
					(set-cursor-color "Gray")
					))


;; 全角空白を表示させる。
(setq jaspace-alternate-jaspace-string "□")

;; バックアップファイル保存先
(setq backup-directory-alist
	  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
			backup-directory-alist))

(setq auto-save-file-name-transforms
	  `((".*", (expand-file-name "~/.emacs.d/backup/") t)))


;; matlab-mode 用
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)


;; C++ settings
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(put 'upcase-region 'disabled nil)

(add-hook 'c++-mode-hook
          '(lambda ()
             (c-set-style "bsd") ; k&r、bsd、stroustrup、whitesmith、ellemtel、linuxなどがある。
			 (setq c-basic-offset 4)
			 (c-set-offset 'statement-cont 'c-lineup-math)
			 (c-set-offset 'arglist-close 0)
			 (c-set-offset 'arglist-cont 0)
			 (c-set-offset 'case-label 4)
			 (c-set-offset 'statement-case-intro 4)
			 (c-set-offset 'comment-intro 0)
			 (c-set-offset 'innamespace 0)
             )
		  )


;; Python settings
(add-hook 'python-mode-hook
		  (lambda ()
			(setq-default indent-tabs-mode t)
			(setq-default tab-width 4)
			(setq-default py-indent-tabs-mode t)
			(add-to-list 'write-file-functions 'delete-trailing-whitespace)
			)
		  )
