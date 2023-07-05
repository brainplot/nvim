vim.filetype.add({
	filename = {
		[".clang-format"] = "yaml",
		[".lua-format"] = "yaml",
	},
	pattern = {
		[".*/etc/kubernetes/admin%.conf"] = "yaml",
		[".*/.kube/config"] = "yaml",
		[".*/.ssh/.*%.config"] = "sshconfig",
	},
})
