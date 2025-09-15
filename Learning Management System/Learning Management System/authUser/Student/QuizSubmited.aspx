<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="QuizSubmited.aspx.cs" Inherits="Learning_Management_System.authUser.Student.QuizSubmited" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


  <style>
        .quiz-submitted-block {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(25, 118, 210, 0.10);
            padding: 2.5rem 2.5rem 2rem 2.5rem;
            margin: 3rem auto 2rem auto;
            max-width: 700px;
            border-left: 7px solid #1976d2;
            text-align: center;
        }
        .quiz-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1976d2;
            margin-bottom: 0.7rem;
        }
        .quiz-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1.1rem 2.2rem;
            justify-content: center;
            margin-bottom: 1.2rem;
        }
        .quiz-badge {
            background: #e3f2fd;
            color: #1976d2;
            border-radius: 1em;
            padding: 0.3em 1em;
            font-size: 1.08rem;
            font-weight: 500;
        }
        .quiz-badge.type { background: #f0ecf9; color: #6f42c1; }
        .quiz-badge.date { background: #f1f3f4; color: #495057; }
        .quiz-badge.questions { background: #fff3cd; color: #856404; }
        .quiz-desc {
            color: #495057;
            font-size: 1.15rem;
            margin-bottom: 1.5rem;
        }
        .quiz-message {
            font-size: 1.3rem;
            color: #388e3c;
            font-weight: 600;
            margin-bottom: 1.2rem;
        }
        .quiz-score {
            font-size: 2.7rem;
            font-weight: 900;
            color: #d32f2f;
            margin-bottom: 1.2rem;
        }
        .quiz-actions {
            display: flex;
            gap: 1.2rem;
            justify-content: center;
            margin-top: 1.5rem;
        }
        .btn-quiz {
            padding: 0.7em 2.2em;
            font-size: 1.15rem;
            border-radius: 0.5em;
            border: none;
            font-weight: 700;
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(25, 118, 210, 0.07);
        }
        .btn-attempt {
            background: #1976d2;
            color: #fff;
        }
        .btn-attempt:disabled {
            background: #f1f3f4;
            color: #b0b0b0;
            cursor: not-allowed;
        }
        .btn-review {
            background: #f8d7da;
            color: #721c24;
        }
        .btn-review:hover {
            background: #f5c6cb;
            color: #721c24;
        }
        .out-of-attempt {
            color: #d32f2f;
            font-size: 1.1rem;
            margin-top: 0.7rem;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  <div class="quiz-submitted-block">
        <div class="quiz-title" id="quizTitle"><!-- Quiz Title --></div>
        <div class="quiz-meta">
            <span class="quiz-badge type" id="quizType"></span>
            <span class="quiz-badge date" id="quizTime"></span>
            <span class="quiz-badge questions" id="quizNumQuestions"></span>
        </div>
        <div class="quiz-desc" id="quizDescription"><!-- Quiz Description --></div>
        <div class="quiz-message" id="quizMessage">Quiz Submitted</div>
        <div class="quiz-score" id="quizScore">--/--</div>
        <div class="quiz-actions">
            <button class="btn-quiz btn-attempt" id="btnAttempt">Attempt Again</button>
            <button class="btn-quiz btn-review" id="btnReview">Review Answers</button>
        </div>
        <div class="out-of-attempt" id="outOfAttemptMsg" style="display:none;">Out of attempt</div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // On page load, fetch quiz info and submission result
        $(document).ready(function() {
            var urlParams = new URLSearchParams(window.location.search);
            var quizId = urlParams.get('quizId');
            var status = urlParams.get('status') || 'submitted';
            // Fetch quiz info and submission result
            $.ajax({
                type: 'POST',
                url: 'QuizQuestion.aspx/GetQuizInfo',
                data: JSON.stringify({ quizId: quizId }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(res) {
                    var info = res.d ? (typeof res.d === 'string' ? JSON.parse(res.d) : res.d) : {};
                    $('#quizTitle').text(info.Title);
                    $('#quizType').text(info.Type);
                    $('#quizTime').text(info.Duration + ' min');
                    $('#quizNumQuestions').text(info.NumQuestions + ' Questions');
                    $('#quizDescription').text(info.Description);
                    // Fetch latest submission for score and attempts
                    $.ajax({
                        type: 'POST',
                        url: 'QuizSubmited.aspx/GetSubmissionResult',
                        data: JSON.stringify({ quizId: quizId }),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function(res2) {
                            var sub = res2.d ? (typeof res2.d === 'string' ? JSON.parse(res2.d) : res2.d) : {};
                            $('#quizScore').text((sub.Score !== undefined ? sub.Score : '--') + '/' + (info.NumQuestions || '--'));
                            if (status === 'timeout') {
                                $('#quizMessage').text('Time Out');
                            } else {
                                $('#quizMessage').text('Quiz Submitted');
                            }
                            if (sub.AttemptsLeft <= 0) {
                                $('#btnAttempt').prop('disabled', true);
                                $('#outOfAttemptMsg').show();
                            } else {
                                $('#btnAttempt').prop('disabled', false);
                                $('#outOfAttemptMsg').hide();
                            }
                        }
                    });
                }
            });
            $('#btnAttempt').on('click', function() {
                if (!$(this).prop('disabled')) {
                    window.location.href = 'QuizQuestion.aspx?quizId=' + quizId;
                }
            });
            $('#btnReview').on('click', function() {
                window.location.href = 'QuizAnswer.aspx?quizId=' + quizId;
            });
        });
    </script>


</asp:Content>
