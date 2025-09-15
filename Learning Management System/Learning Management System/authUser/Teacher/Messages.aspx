<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Messages" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<title>Messages - Teacher</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<style>
	body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
	.messages-container { padding: 20px; max-width: 1200px; margin: 0 auto; }
	.page-header { background: linear-gradient(135deg, #2c2b7c, #0056b3); color: white; padding: 30px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 8px 25px rgba(44, 43, 124, 0.15); }
	.messages-card { background: white; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); overflow: hidden; display: flex; min-height: 600px; }
	.messages-list { width: 340px; border-right: 1px solid #f1f3f4; background: #f8f9fa; overflow-y: auto; }
	.messages-list-header { padding: 20px; border-bottom: 1px solid #e9ecef; background: #f8f9fa; }
	.messages-list-search { width: 100%; border-radius: 8px; border: 1px solid #e9ecef; padding: 8px 12px; margin-bottom: 10px; }
	.message-user { display: flex; align-items: center; gap: 12px; padding: 16px 20px; cursor: pointer; border-bottom: 1px solid #f1f3f4; transition: background 0.2s; }
	.message-user:hover, .message-user.active { background: #e3e8ff; }
	.user-avatar { width: 48px; height: 48px; border-radius: 50%; background: #e3e8ff; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: #2c2b7c; font-weight: 500; }
	.user-info { flex: 1; }
	.user-name { font-weight: 600; color: #2c2b7c; margin-bottom: 2px; }
	.user-lastmsg { color: #6c757d; font-size: 0.95rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
	.user-time { font-size: 0.85rem; color: #adb5bd; }
	.conversation-view { flex: 1; display: flex; flex-direction: column; }
	.conversation-header { padding: 20px; border-bottom: 1px solid #e9ecef; background: #f8f9fa; display: flex; align-items: center; gap: 16px; }
	.conversation-header .user-avatar { width: 40px; height: 40px; font-size: 1.2rem; }
	.conversation-header .user-name { font-size: 1.1rem; margin-bottom: 0; }
	.messages-body { flex: 1; padding: 30px 30px 20px 30px; overflow-y: auto; background: #f8f9fa; }
	.message-row { display: flex; margin-bottom: 18px; }
	.message-row.sent { justify-content: flex-end; }
	.message-bubble { max-width: 60%; padding: 14px 20px; border-radius: 18px; font-size: 1rem; background: #e3e8ff; color: #2c2b7c; box-shadow: 0 2px 8px rgba(44,43,124,0.06); position: relative; }
	.message-row.sent .message-bubble { background: #2c2b7c; color: white; border-bottom-right-radius: 6px; }
	.message-row.received .message-bubble { background: #e3e8ff; color: #2c2b7c; border-bottom-left-radius: 6px; }
	.message-time { font-size: 0.8rem; color: #adb5bd; margin-top: 4px; text-align: right; }
	.message-input-area { padding: 18px 24px; border-top: 1px solid #e9ecef; background: #fff; display: flex; gap: 12px; align-items: center; }
	.message-input { flex: 1; border-radius: 8px; border: 1px solid #e9ecef; padding: 12px 16px; font-size: 1rem; }
	.send-btn { background: #2c2b7c; color: white; border: none; border-radius: 8px; padding: 10px 22px; font-weight: 500; transition: background 0.2s; }
	.send-btn:hover { background: #0056b3; }
	@media (max-width: 900px) { .messages-card { flex-direction: column; } .messages-list { width: 100%; min-width: 0; border-right: none; border-bottom: 1px solid #f1f3f4; } .conversation-view { min-height: 350px; } }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="messages-container">
	<!-- Page Header -->
	<div class="page-header mb-4 fade-in">
		<h1 class="mb-2"><i class="fas fa-envelope me-3"></i>Messages</h1>
		<p class="mb-0 opacity-75">Communicate with students, parents, and staff</p>
	</div>
	<div class="messages-card fade-in">
		<!-- Messages List -->
		<div class="messages-list">
			<div class="messages-list-header">
				<input type="text" class="messages-list-search" placeholder="Search conversations...">
			</div>
			<div id="messagesListBody">
				<!-- Dynamic user list -->
				<div class="message-user active">
					<div class="user-avatar"><i class="fas fa-user"></i></div>
					<div class="user-info">
						<div class="user-name">Ama Osei</div>
						<div class="user-lastmsg">Hi, can you send the assignment details?</div>
					</div>
					<div class="user-time">09:12</div>
				</div>
				<div class="message-user">
					<div class="user-avatar"><i class="fas fa-user"></i></div>
					<div class="user-info">
						<div class="user-name">Kwame Mensah</div>
						<div class="user-lastmsg">Thank you for the feedback!</div>
					</div>
					<div class="user-time">Yesterday</div>
				</div>
				<!-- More users... -->
			</div>
		</div>
		<!-- Conversation View -->
		<div class="conversation-view">
			<div class="conversation-header">
				<div class="user-avatar"><i class="fas fa-user"></i></div>
				<div class="user-name">Ama Osei</div>
			</div>
			<div class="messages-body" id="conversationBody">
				<!-- Dynamic messages -->
				<div class="message-row received">
					<div class="message-bubble">Hi, can you send the assignment details?</div>
				</div>
				<div class="message-row sent">
					<div class="message-bubble">Sure! I will send it shortly.</div>
				</div>
				<div class="message-row received">
					<div class="message-bubble">Thank you!</div>
				</div>
			</div>V
			<div class="message-input-area">
				<input type="text" class="message-input" placeholder="Type your message...">
				<button class="send-btn"><i class="fas fa-paper-plane me-2"></i>Send</button>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>  